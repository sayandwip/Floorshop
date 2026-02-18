import Foundation
import ActivityKit

struct SpeedData {
    let downloadSpeed: Double  // bytes per second
    let uploadSpeed: Double    // bytes per second
    let connectionType: ConnectionType
    let timestamp: Date
    
    enum ConnectionType: String, Codable {
        case wifi = "WiFi"
        case cellular = "Cellular"
        case none = "No Connection"
        
        var icon: String {
            switch self {
            case .wifi: return "wifi"
            case .cellular: return "antenna.radiowaves.left.and.right"
            case .none: return "wifi.slash"
            }
        }
    }
    
    var formattedDownload: String {
        Self.formatSpeed(downloadSpeed)
    }
    
    var formattedUpload: String {
        Self.formatSpeed(uploadSpeed)
    }
    
    static func formatSpeed(_ bytesPerSecond: Double) -> String {
        if bytesPerSecond < 1024 {
            return String(format: "%.0f B/s", bytesPerSecond)
        } else if bytesPerSecond < 1024 * 1024 {
            return String(format: "%.1f KB/s", bytesPerSecond / 1024)
        } else if bytesPerSecond < 1024 * 1024 * 1024 {
            return String(format: "%.1f MB/s", bytesPerSecond / (1024 * 1024))
        } else {
            return String(format: "%.2f GB/s", bytesPerSecond / (1024 * 1024 * 1024))
        }
    }
    
    static let zero = SpeedData(
        downloadSpeed: 0,
        uploadSpeed: 0,
        connectionType: .none,
        timestamp: Date()
    )
}

// MARK: - Live Activity Attributes

struct SpeedMeterAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var downloadSpeed: Double
        var uploadSpeed: Double
        var connectionType: String
        var connectionIcon: String
    }
    
    var startTime: Date
}
