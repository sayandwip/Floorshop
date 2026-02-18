import WidgetKit
import SwiftUI
import Network

// MARK: - Timeline Provider

struct SpeedMeterTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> SpeedMeterEntry {
        SpeedMeterEntry(
            date: Date(),
            downloadSpeed: 12_500_000,
            uploadSpeed: 3_200_000,
            connectionType: "WiFi",
            connectionIcon: "wifi"
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SpeedMeterEntry) -> Void) {
        let entry = SpeedMeterEntry(
            date: Date(),
            downloadSpeed: getStoredDownloadSpeed(),
            uploadSpeed: getStoredUploadSpeed(),
            connectionType: getStoredConnectionType(),
            connectionIcon: getStoredConnectionIcon()
        )
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SpeedMeterEntry>) -> Void) {
        let entry = SpeedMeterEntry(
            date: Date(),
            downloadSpeed: getStoredDownloadSpeed(),
            uploadSpeed: getStoredUploadSpeed(),
            connectionType: getStoredConnectionType(),
            connectionIcon: getStoredConnectionIcon()
        )
        
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    private var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: "group.com.sayandwips.speedmeter") ?? .standard
    }
    
    private func getStoredDownloadSpeed() -> Double {
        sharedDefaults.double(forKey: "lastDownloadSpeed")
    }
    
    private func getStoredUploadSpeed() -> Double {
        sharedDefaults.double(forKey: "lastUploadSpeed")
    }
    
    private func getStoredConnectionType() -> String {
        sharedDefaults.string(forKey: "connectionType") ?? "No Connection"
    }
    
    private func getStoredConnectionIcon() -> String {
        sharedDefaults.string(forKey: "connectionIcon") ?? "wifi.slash"
    }
}

// MARK: - Entry

struct SpeedMeterEntry: TimelineEntry {
    let date: Date
    let downloadSpeed: Double
    let uploadSpeed: Double
    let connectionType: String
    let connectionIcon: String
}

// MARK: - Widget Views

struct SpeedMeterWidgetSmallView: View {
    let entry: SpeedMeterEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: entry.connectionIcon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
                Text(entry.connectionType)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.cyan)
                    Text(formatSpeed(entry.downloadSpeed))
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.green)
                    Text(formatSpeed(entry.uploadSpeed))
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            
            Text(entry.date, style: .time)
                .font(.system(size: 9, design: .rounded))
                .foregroundStyle(.tertiary)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct SpeedMeterWidgetMediumView: View {
    let entry: SpeedMeterEntry
    
    var body: some View {
        HStack(spacing: 20) {
            // Connection info
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: entry.connectionIcon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.blue)
                    Text(entry.connectionType)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                }
                
                Text("Last updated")
                    .font(.system(size: 10, design: .rounded))
                    .foregroundColor(.secondary)
                Text(entry.date, style: .time)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            // Download
            VStack(spacing: 4) {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.cyan)
                Text(formatSpeed(entry.downloadSpeed))
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                Text("Download")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            // Upload
            VStack(spacing: 4) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.green)
                Text(formatSpeed(entry.uploadSpeed))
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                Text("Upload")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

private func formatSpeed(_ bytesPerSecond: Double) -> String {
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

// MARK: - Widget Definition

struct SpeedMeterWidget: Widget {
    let kind: String = "SpeedMeterWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SpeedMeterTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                SpeedMeterWidgetSmallView(entry: entry)
            } else {
                SpeedMeterWidgetSmallView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Internet Speed")
        .description("Shows your current internet speed and connection type.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Widget Bundle

@main
struct SpeedMeterWidgetBundle: WidgetBundle {
    var body: some Widget {
        SpeedMeterWidget()
        SpeedMeterLiveActivity()
    }
}
