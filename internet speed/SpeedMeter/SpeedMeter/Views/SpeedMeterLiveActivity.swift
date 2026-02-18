import ActivityKit
import SwiftUI
import WidgetKit

struct SpeedMeterLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SpeedMeterAttributes.self) { context in
            lockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Label("Download", systemImage: "arrow.down.circle.fill")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(SpeedData.formatSpeed(context.state.downloadSpeed))
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.cyan)
                            .contentTransition(.numericText())
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Label("Upload", systemImage: "arrow.up.circle.fill")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                        Text(SpeedData.formatSpeed(context.state.uploadSpeed))
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                            .contentTransition(.numericText())
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    HStack(spacing: 4) {
                        Image(systemName: context.state.connectionIcon)
                            .font(.system(size: 12))
                        Text(context.state.connectionType)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                    }
                    .foregroundColor(.secondary)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    EmptyView()
                }
            } compactLeading: {
                HStack(spacing: 3) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.cyan)
                    Text(SpeedData.formatSpeed(context.state.downloadSpeed))
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(.cyan)
                        .contentTransition(.numericText())
                }
            } compactTrailing: {
                HStack(spacing: 3) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.green)
                    Text(SpeedData.formatSpeed(context.state.uploadSpeed))
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(.green)
                        .contentTransition(.numericText())
                }
            } minimal: {
                Image(systemName: "speedometer")
                    .font(.system(size: 12))
                    .foregroundColor(.cyan)
            }
        }
    }
    
    // MARK: - Lock Screen Banner
    
    @ViewBuilder
    private func lockScreenView(context: ActivityViewContext<SpeedMeterAttributes>) -> some View {
        HStack(spacing: 16) {
            // Connection type
            VStack(spacing: 4) {
                Image(systemName: context.state.connectionIcon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.blue)
                Text(context.state.connectionType)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .frame(width: 60)
            
            Divider()
                .frame(height: 35)
            
            // Download
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.cyan)
                    Text("Download")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }
                Text(SpeedData.formatSpeed(context.state.downloadSpeed))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.cyan)
                    .contentTransition(.numericText())
            }
            
            Spacer()
            
            // Upload
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.green)
                    Text("Upload")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }
                Text(SpeedData.formatSpeed(context.state.uploadSpeed))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.green)
                    .contentTransition(.numericText())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemBackground))
    }
}
