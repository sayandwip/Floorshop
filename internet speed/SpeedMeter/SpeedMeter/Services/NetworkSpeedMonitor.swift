import Foundation
import Network
import Combine
import ActivityKit

@MainActor
final class NetworkSpeedMonitor: ObservableObject {
    @Published var currentSpeed: SpeedData = .zero
    @Published var isMonitoring = false
    @Published var speedHistory: [SpeedData] = []
    @Published var peakDownload: Double = 0
    @Published var peakUpload: Double = 0
    @Published var averageDownload: Double = 0
    @Published var averageUpload: Double = 0
    
    private var timer: Timer?
    private let pathMonitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "com.speedmeter.networkmonitor")
    
    private var previousBytesReceived: UInt64 = 0
    private var previousBytesSent: UInt64 = 0
    private var previousTimestamp: Date?
    
    @Published var connectionType: SpeedData.ConnectionType = .none
    
    private var liveActivity: Activity<SpeedMeterAttributes>?
    
    static let shared = NetworkSpeedMonitor()
    
    private init() {
        startPathMonitor()
    }
    
    // MARK: - Path Monitor
    
    private func startPathMonitor() {
        pathMonitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                guard let self else { return }
                if path.status == .satisfied {
                    if path.usesInterfaceType(.wifi) {
                        self.connectionType = .wifi
                    } else if path.usesInterfaceType(.cellular) {
                        self.connectionType = .cellular
                    }
                } else {
                    self.connectionType = .none
                }
            }
        }
        pathMonitor.start(queue: monitorQueue)
    }
    
    // MARK: - Speed Monitoring
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        isMonitoring = true
        speedHistory.removeAll()
        peakDownload = 0
        peakUpload = 0
        
        let (rx, tx) = getNetworkBytes()
        previousBytesReceived = rx
        previousBytesSent = tx
        previousTimestamp = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.measureSpeed()
            }
        }
        
        startLiveActivity()
    }
    
    func stopMonitoring() {
        isMonitoring = false
        timer?.invalidate()
        timer = nil
        previousTimestamp = nil
        stopLiveActivity()
    }
    
    private func measureSpeed() {
        let (currentRx, currentTx) = getNetworkBytes()
        let now = Date()
        
        guard let prevTime = previousTimestamp else {
            previousBytesReceived = currentRx
            previousBytesSent = currentTx
            previousTimestamp = now
            return
        }
        
        let elapsed = now.timeIntervalSince(prevTime)
        guard elapsed > 0 else { return }
        
        let rxDiff = currentRx > previousBytesReceived ? currentRx - previousBytesReceived : 0
        let txDiff = currentTx > previousBytesSent ? currentTx - previousBytesSent : 0
        
        let downloadSpeed = Double(rxDiff) / elapsed
        let uploadSpeed = Double(txDiff) / elapsed
        
        let speed = SpeedData(
            downloadSpeed: downloadSpeed,
            uploadSpeed: uploadSpeed,
            connectionType: connectionType,
            timestamp: now
        )
        
        currentSpeed = speed
        speedHistory.append(speed)
        
        if speedHistory.count > 60 {
            speedHistory.removeFirst()
        }
        
        peakDownload = max(peakDownload, downloadSpeed)
        peakUpload = max(peakUpload, uploadSpeed)
        
        let totalDown = speedHistory.reduce(0) { $0 + $1.downloadSpeed }
        let totalUp = speedHistory.reduce(0) { $0 + $1.uploadSpeed }
        averageDownload = totalDown / Double(speedHistory.count)
        averageUpload = totalUp / Double(speedHistory.count)
        
        previousBytesReceived = currentRx
        previousBytesSent = currentTx
        previousTimestamp = now
        
        saveToSharedDefaults(speed: speed)
        updateLiveActivity(speed: speed)
    }
    
    /// Reads total bytes received and sent from system network interfaces via `getifaddrs`.
    private func getNetworkBytes() -> (received: UInt64, sent: UInt64) {
        var totalReceived: UInt64 = 0
        var totalSent: UInt64 = 0
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else {
            return (0, 0)
        }
        defer { freeifaddrs(ifaddr) }
        
        var cursor: UnsafeMutablePointer<ifaddrs>? = firstAddr
        while let addr = cursor {
            let name = String(cString: addr.pointee.ifa_name)
            
            // en0 = WiFi, pdp_ip0 = Cellular
            if name == "en0" || name == "pdp_ip0" || name.hasPrefix("pdp_ip") {
                if let data = addr.pointee.ifa_data {
                    let networkData = data.assumingMemoryBound(to: if_data.self)
                    totalReceived += UInt64(networkData.pointee.ifi_ibytes)
                    totalSent += UInt64(networkData.pointee.ifi_obytes)
                }
            }
            cursor = addr.pointee.ifa_next
        }
        
        return (totalReceived, totalSent)
    }
    
    // MARK: - Shared Defaults (for Widget)
    
    private func saveToSharedDefaults(speed: SpeedData) {
        let defaults = UserDefaults(suiteName: "group.com.sayandwips.speedmeter") ?? .standard
        defaults.set(speed.downloadSpeed, forKey: "lastDownloadSpeed")
        defaults.set(speed.uploadSpeed, forKey: "lastUploadSpeed")
        defaults.set(speed.connectionType.rawValue, forKey: "connectionType")
        defaults.set(speed.connectionType.icon, forKey: "connectionIcon")
    }
    
    // MARK: - Live Activity
    
    private func startLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        let attributes = SpeedMeterAttributes(startTime: Date())
        let initialState = SpeedMeterAttributes.ContentState(
            downloadSpeed: 0,
            uploadSpeed: 0,
            connectionType: connectionType.rawValue,
            connectionIcon: connectionType.icon
        )
        
        do {
            let content = ActivityContent(state: initialState, staleDate: nil)
            liveActivity = try Activity<SpeedMeterAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
        } catch {
            print("Failed to start Live Activity: \(error)")
        }
    }
    
    private func updateLiveActivity(speed: SpeedData) {
        guard let activity = liveActivity else { return }
        
        let updatedState = SpeedMeterAttributes.ContentState(
            downloadSpeed: speed.downloadSpeed,
            uploadSpeed: speed.uploadSpeed,
            connectionType: speed.connectionType.rawValue,
            connectionIcon: speed.connectionType.icon
        )
        
        Task {
            let content = ActivityContent(state: updatedState, staleDate: nil)
            await activity.update(content)
        }
    }
    
    private func stopLiveActivity() {
        Task {
            let finalState = SpeedMeterAttributes.ContentState(
                downloadSpeed: 0,
                uploadSpeed: 0,
                connectionType: "Stopped",
                connectionIcon: "stop.circle"
            )
            let content = ActivityContent(state: finalState, staleDate: nil)
            await liveActivity?.end(content, dismissalPolicy: .immediate)
            liveActivity = nil
        }
    }
}
