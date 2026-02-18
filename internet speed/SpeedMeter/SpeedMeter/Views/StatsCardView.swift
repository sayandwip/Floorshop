import SwiftUI

struct StatsCardView: View {
    let peakDownload: Double
    let peakUpload: Double
    let averageDownload: Double
    let averageUpload: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Statistics")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
            
            HStack(spacing: 16) {
                statItem(title: "Peak ↓", value: SpeedData.formatSpeed(peakDownload), color: .blue)
                Divider().frame(height: 40)
                statItem(title: "Peak ↑", value: SpeedData.formatSpeed(peakUpload), color: .green)
                Divider().frame(height: 40)
                statItem(title: "Avg ↓", value: SpeedData.formatSpeed(averageDownload), color: .cyan)
                Divider().frame(height: 40)
                statItem(title: "Avg ↑", value: SpeedData.formatSpeed(averageUpload), color: .mint)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private func statItem(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(color)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity)
    }
}
