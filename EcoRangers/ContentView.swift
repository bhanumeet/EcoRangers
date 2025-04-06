import SwiftUI

struct ContentView: View {
    @State private var score: Int = 0
    @State private var detectedTrashItems: [String] = []
    @State private var debugText: String = "No detections yet."
    
    var body: some View {
        ZStack {
            // Camera view fills the background.
            CameraView(detectedTrashItems: $detectedTrashItems, debugText: $debugText)
                .edgesIgnoringSafeArea(.all)
            
            // Top overlay with score (top left) and detected trash list (top right)
            VStack {
                HStack {
                    // Score on top left.
                    Text("Score: \(score)")
                        .font(.headline)
                        .padding(10)
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    // Detected trash items on top right.
                    if !detectedTrashItems.isEmpty {
                        VStack(alignment: .trailing) {
                            Text("Detected Trash:")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            ForEach(detectedTrashItems, id: \.self) { item in
                                Text(item.capitalized)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(10)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                        .padding(.trailing, 10)
                    }
                }
                Spacer()
            }
            
            // Bottom overlay: Fixed "Pick" button in the center.
            VStack {
                Spacer()
                if let trash = detectedTrashItems.first {
                    Button(action: {
                        score += 10
                    }) {
                        Text("Pick \(trash.capitalized)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(25)
                            .padding(.horizontal, 50)
                    }
                    .padding(.bottom, 30)
                } else {
                    // If no trash is detected, show a disabled state.
                    Text("No Trash Detected")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(25)
                        .padding(.horizontal, 50)
                        .padding(.bottom, 30)
                }
            }
        }
    }
}

// Wrap the UIKit CameraViewController in SwiftUI.
struct CameraView: UIViewControllerRepresentable {
    @Binding var detectedTrashItems: [String]
    @Binding var debugText: String

    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraVC = CameraViewController()
        cameraVC.delegate = context.coordinator
        return cameraVC
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // No update needed.
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, CameraViewControllerDelegate {
        var parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        // Pass detected trash items and debug info back to SwiftUI.
        func cameraViewController(_ controller: CameraViewController,
                                  didDetectTrashItems items: [String],
                                  debugInfo: String) {
            DispatchQueue.main.async {
                self.parent.detectedTrashItems = items
                self.parent.debugText = debugInfo
            }
        }
    }
}
