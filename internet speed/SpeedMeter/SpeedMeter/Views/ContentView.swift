import SwiftUI

struct ContentView: View {
    @StateObject private var monitor = NetworkSpeedMonitor.shared
    @State private var animateGlow = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        connectionBanner
                        gaugesSection
                        controlButton
                        
                        if monitor.isMonitoring {
                            SpeedChartView(history: monitor.speedHistory)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            
                            StatsCardView(
                                peakDownload: monitor.peakDownload,
                                peakUpload: monitor.peakUpload,
                                averageDownload: monitor.averageDownload,
                                averageUpload: monitor.averageUpload
                            )
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            
                            liveActivityHint
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .navigationTitle("SpeedMeter")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Background
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                monitor.isMonitoring ? Color.blue.opacity(0.05) : Color(.systemBackground)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Connection Banner
    
    private var connectionBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: monitor.connectionType.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(connectionColor)
                .symbolEffect(.variableColor, isActive: monitor.isMonitoring)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(monitor.connectionType.rawValue)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                
                if monitor.isMonitoring {
                    Text("Monitoring active")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.secondary)
                } else {
                    Text("Tap Start to begin monitoring")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if monitor.isMonitoring {
                Circle()
                    .fill(.green)
                    .frame(width: 8, height: 8)
                    .shadow(color: .green.opacity(0.5), radius: 4)
                    .scaleEffect(animateGlow ? 1.3 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateGlow)
                    .onAppear { animateGlow = true }
                    .onDisappear { animateGlow = false }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var connectionColor: Color {
        switch monitor.connectionType {
        case .wifi: return .blue
        case .cellular: return .orange
        case .none: return .gray
        }
    }
    
    // MARK: - Gauges
    
    private var gaugesSection: some View {
        HStack(spacing: 30) {
            SpeedGaugeView(
                speed: monitor.currentSpeed.downloadSpeed,
                maxSpeed: max(monitor.peakDownload, 1024 * 1024),
                label: "Download",
                color: .blue
            )
            
            SpeedGaugeView(
                speed: monitor.currentSpeed.uploadSpeed,
                maxSpeed: max(monitor.peakUpload, 1024 * 1024),
                label: "Upload",
                color: .green
            )
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - Control Button
    
    private var controlButton: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                if monitor.isMonitoring {
                    monitor.stopMonitoring()
                } else {
                    monitor.startMonitoring()
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: monitor.isMonitoring ? "stop.fill" : "play.fill")
                Text(monitor.isMonitoring ? "Stop Monitoring" : "Start Monitoring")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: monitor.isMonitoring
                                ? [.red, .orange]
                                : [.blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(
                        color: (monitor.isMonitoring ? Color.red : Color.blue).opacity(0.3),
                        radius: 10,
                        y: 5
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Live Activity Hint
    
    private var liveActivityHint: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.blue)
            
            Text("Speed is shown on your Lock Screen and Dynamic Island while monitoring is active.")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.08))
        )
    }
}

#Preview {
    ContentView()
}
