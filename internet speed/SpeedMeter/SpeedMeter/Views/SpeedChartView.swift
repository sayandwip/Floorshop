import SwiftUI
import Charts

struct SpeedChartView: View {
    let history: [SpeedData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Speed History")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
            
            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(Array(history.enumerated()), id: \.offset) { index, data in
                        LineMark(
                            x: .value("Time", index),
                            y: .value("Speed", data.downloadSpeed / 1024)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(
                            x: .value("Time", index),
                            y: .value("Speed", data.downloadSpeed / 1024)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .blue.opacity(0.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartYAxisLabel("KB/s")
                .chartXAxis(.hidden)
                .frame(height: 150)
                .animation(.easeInOut(duration: 0.3), value: history.count)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}
