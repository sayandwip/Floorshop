import SwiftUI

struct SpeedGaugeView: View {
    let speed: Double
    let maxSpeed: Double
    let label: String
    let color: Color
    
    private var progress: Double {
        guard maxSpeed > 0 else { return 0 }
        return min(speed / maxSpeed, 1.0)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(color.opacity(0.15), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(135))
                
                Circle()
                    .trim(from: 0, to: progress * 0.75)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [color.opacity(0.5), color]),
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(135))
                    .animation(.easeInOut(duration: 0.5), value: progress)
                
                VStack(spacing: 2) {
                    Text(SpeedData.formatSpeed(speed))
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .contentTransition(.numericText())
                    
                    Text(label)
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 120, height: 120)
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        SpeedGaugeView(speed: 5_000_000, maxSpeed: 10_000_000, label: "Download", color: .blue)
        SpeedGaugeView(speed: 2_000_000, maxSpeed: 10_000_000, label: "Upload", color: .green)
    }
    .padding()
}
