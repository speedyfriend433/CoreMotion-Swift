import SwiftUI

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()
    @State private var isUpdating = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Pitch: \(motionManager.pitch, specifier: "%.2f")")
                Text("Roll: \(motionManager.roll, specifier: "%.2f")")
                Text("Yaw: \(motionManager.yaw, specifier: "%.2f")")
                
                HStack {
                    Button(action: {
                        if isUpdating {
                            motionManager.stopUpdates()
                        } else {
                            motionManager.startUpdates()
                        }
                        isUpdating.toggle()
                    }) {
                        Text(isUpdating ? "Stop" : "Start")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Toggle(isOn: $isDarkMode) {
                    Text("Dark Mode")
                }
                .padding()
                
                LineGraph(data: motionManager.pitchHistory, title: "Pitch History")
                    .frame(height: 200)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                LineGraph(data: motionManager.rollHistory, title: "Roll History")
                    .frame(height: 200)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                LineGraph(data: motionManager.yawHistory, title: "Yaw History")
                    .frame(height: 200)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct LineGraph: View {
    var data: [Double]
    var title: String
    
    @State private var selectedIndex: Int? = nil
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(.bottom, 10)
            
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let maxY = (data.max() ?? 1.0) == 0 ? 1 : (data.max() ?? 1.0)
                let minY = data.min() ?? 0.0
                
                let scaleX = width / CGFloat(data.count - 1)
                let scaleY = height / CGFloat(maxY - minY)
                
                ZStack {
                    Path { path in
                        guard data.count > 1 else { return }
                        
                        path.move(to: CGPoint(x: 0, y: height - CGFloat(data[0] - minY) * scaleY))
                        
                        for index in data.indices {
                            let x = CGFloat(index) * scaleX
                            let y = height - CGFloat(data[index] - minY) * scaleY
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)
                    
                    if let selectedIndex = selectedIndex {
                        let x = CGFloat(selectedIndex) * scaleX
                        let y = height - CGFloat(data[selectedIndex] - minY) * scaleY
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                            .position(x: x, y: y)
                        Text(String(format: "%.2f", data[selectedIndex]))
                            .position(x: x, y: y - 20)
                    }
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let location = value.location
                            let index = Int((location.x / width) * CGFloat(data.count - 1))
                            if index >= 0 && index < data.count {
                                selectedIndex = index
                            }
                        }
                        .onEnded { _ in
                            selectedIndex = nil
                        }
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}