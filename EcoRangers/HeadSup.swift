//
//  HeadSupView.swift
//  EcoRangers
//
//  Created by [Your Name] on [Date]
//

import SwiftUI
import CoreMotion
import UIKit

// MARK: - Orientation Controller (No AppDelegate Required)
class OrientationController {
    static let shared = OrientationController()
    
    /// Lock the view to landscape orientation.
    func lockLandscape() {
        if #available(iOS 16.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
            }
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    /// Reset the orientation to portrait.
    func resetOrientation() {
        if #available(iOS 16.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .all))
            }
        } else {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}

// MARK: - Landscape Hosting Wrapper
/// A wrapper to present a SwiftUI view in landscape orientation.
struct LandscapeView<Content: View>: UIViewControllerRepresentable {
    let content: Content
    
    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        let controller = UIHostingController(rootView: content)
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
        uiViewController.rootView = content
    }
}

// MARK: - Trash Item Model
struct TrashItem {
    let name: String
    let hint: String
}

// MARK: - Motion Manager
class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    @Published var pitch: Double = 0.0
    
    init() {
        startUpdates()
    }
    
    func startUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.2
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
                guard let motion = motion else { return }
                self?.pitch = motion.attitude.pitch
            }
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}

// MARK: - Haptic Feedback Helper
func triggerHapticFeedback(style: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(style)
}

// MARK: - HeadSupView (HeadsUp Game in Landscape Only)
struct HeadSupView: View {
    // Timer state.
    @State private var timeRemaining: Int = 60
    @State private var timerRunning = false
    
    // Game state.
    @State private var currentIndex: Int = 0
    @State private var score: Int = 0
    @State private var actionTaken = false
    @State private var showGameOver = false
    
    // Original list of trash items.
    private let trashItems: [TrashItem] = [
        TrashItem(name: "PLASTIC BOTTLE", hint: "600 billion dumped in oceans yearly. Takes 450 years to decompose."),
        TrashItem(name: "ALUMINUM CAN", hint: "2.7 million cans wasted every 30 minutes. Recycling saves 95% energy."),
        TrashItem(name: "STYROFOAM CUP", hint: "500+ year decomposition. Releases toxic styrene when burned."),
        TrashItem(name: "CIGARETTE BUTT", hint: "Trillions discarded annually. Contains arsenic and lead."),
        TrashItem(name: "PLASTIC BAG", hint: "Kills 100,000 marine animals yearly."),
        TrashItem(name: "PAPER", hint: "40% of global waste. Recycling saves trees."),
        TrashItem(name: "PLASTIC STRAW", hint: "500 million used daily in US. Rarely recycled."),
        TrashItem(name: "FOOD WRAPPER", hint: "23% of landfill waste. Often non-recyclable."),
        TrashItem(name: "FAST FOOD CONTAINER", hint: "Significant urban litter waste."),
        TrashItem(name: "SODA CAN", hint: "180 billion produced yearly. Recycling rate ~50%."),
        TrashItem(name: "PLASTIC UTENSILS", hint: "Decompose in 1000 years. 40 billion thrown away annually in US."),
        TrashItem(name: "DISPOSABLE CUP", hint: "50 billion paper cups discarded yearly (US)."),
        TrashItem(name: "CHIP BAG", hint: "Multi-layer mix, impossible to recycle."),
        TrashItem(name: "COFFEE POD", hint: "56 billion pods in landfills. 500 years to decompose."),
        TrashItem(name: "PLASTIC BOTTLE CAP", hint: "Top 5 ocean pollutants."),
        TrashItem(name: "BROKEN GLASS", hint: "1 million years to decompose."),
        TrashItem(name: "OLD NEWSPAPER", hint: "10 million tons wasted annually in US."),
        TrashItem(name: "USED BATTERY", hint: "Contains mercury/cadmium. 3 billion discarded yearly in US."),
        TrashItem(name: "DISPOSABLE DIAPER", hint: "20 billion in US landfills yearly. 500 years to decompose."),
        TrashItem(name: "ELECTRONICS WASTE", hint: "50 million tons globally. Only 20% recycled."),
        TrashItem(name: "PLASTIC CUTLERY", hint: "Deadly for sea turtles."),
        TrashItem(name: "BEER BOTTLE", hint: "28 billion thrown away annually."),
        TrashItem(name: "PIZZA BOX", hint: "50% unrecyclable due to grease."),
        TrashItem(name: "GUM WRAPPER", hint: "100,000 tons yearly waste."),
        TrashItem(name: "PLASTIC TOY", hint: "90% of toys are plastic."),
        TrashItem(name: "PLASTIC HANGER", hint: "8 billion produced annually worldwide."),
        TrashItem(name: "BALLOON", hint: "Kills 100,000 marine animals annually."),
        TrashItem(name: "PLASTIC CUP", hint: "16 billion used yearly. <1% recycled."),
        TrashItem(name: "PLASTIC PACKAGING", hint: "40% of plastic production for packaging, used once."),
        TrashItem(name: "PLASTIC LIDS", hint: "20 billion produced monthly.")
    ]
    
    // Shuffled trash items for randomized prompt order.
    @State private var randomizedTrashItems: [TrashItem] = []
    
    // Motion manager to detect tilt.
    @ObservedObject private var motionManager = MotionManager()
    @Environment(\.presentationMode) var presentationMode
    
    // Timer.
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Custom Colors.
    // Overall background color.
    private let overallBackground = Color(red: 0.10, green: 0.45, blue: 0.24)
    // Accent colors for side panels.
    private let lightAccent = Color.green.opacity(0.9)
    private let darkAccent = Color.black.opacity(0.6)
    
    var body: some View {
        ZStack {
            // Full screen background.
            overallBackground
                .ignoresSafeArea()
            
            // Main HStack (Left Panel, Center Card, Right Panel).
            HStack(spacing: 0) {
                // Left Panel: Back button, Timer, Score.
                VStack(spacing: 20) {
                    Button(action: {
                        OrientationController.shared.resetOrientation()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(lightAccent)
                            .padding()
                            .background(
                                Circle()
                                    .fill(darkAccent)
                            )
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Timer display.
                    Text("TIME: \(timeRemaining)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(lightAccent)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(darkAccent)
                        )
                    
                    // Score display.
                    Text("SCORE: \(score)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(lightAccent)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(darkAccent)
                        )
                    
                    Spacer()
                }
                .frame(width: 180)
                .background(overallBackground.opacity(0.85))
                
                Divider()
                    .background(lightAccent.opacity(0.5))
                
                // Center Panel: Trash item "card" with previous styling.
                VStack {
                    if showGameOver {
                        VStack(spacing: 20) {
                            Text("GAME OVER!")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.black)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                            
                            Text("Final Score: \(score)")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("You identified \(score) trash items!")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                            
                            Button(action: {
                                // Reset game.
                                timeRemaining = 60
                                score = 0
                                currentIndex = 0
                                showGameOver = false
                                // Shuffle the items again.
                                randomizedTrashItems = trashItems.shuffled()
                                timerRunning = true
                            }) {
                                Text("Play Again")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .padding()
                                    .padding(.horizontal, 20)
                                    .background(
                                        Capsule()
                                            .fill(darkAccent)
                                    )
                            }
                            .padding(.top, 20)
                        }
                        .padding()
                        .background(Color.green)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    } else if currentIndex < randomizedTrashItems.count {
                        VStack(spacing: 30) {
                            Text(randomizedTrashItems[currentIndex].name)
                                .font(.system(size: 60, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                                .padding(.horizontal, 20)
                            
                            Text(randomizedTrashItems[currentIndex].hint)
                                .font(.system(size: 24, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .padding(.horizontal, 40)
                        }
                        .padding()
                        .background(Color.green)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                
                Divider()
                    .background(lightAccent.opacity(0.5))
                
                // Right Panel: Instructions.
                VStack {
                    Spacer()
                    VStack(spacing: 20) {
                        Text("HOW TO PLAY")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(lightAccent)
                            .underline()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "arrow.left")
                                    .font(.title)
                                    .foregroundColor(lightAccent)
                                Text("Tilt DOWN if guessed correctly")
                                    .font(.system(size: 18))
                                    .foregroundColor(lightAccent)
                            }
                            HStack {
                                Image(systemName: "arrow.right")
                                    .font(.title)
                                    .foregroundColor(lightAccent)
                                Text("Tilt UP to pass")
                                    .font(.system(size: 18))
                                    .foregroundColor(lightAccent)
                            }
                        }
                    }
                    .padding()
                    Spacer()
                }
                .frame(width: 180)
                .background(overallBackground.opacity(0.85))
            }
        }
        // Timer logic.
        .onReceive(timer) { _ in
            if timerRunning {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timerRunning = false
                    showGameOver = true
                }
            }
        }
        // Lock to landscape on appear and initialize randomized prompts.
        .onAppear {
            randomizedTrashItems = trashItems.shuffled()
            timerRunning = true
            OrientationController.shared.lockLandscape()
        }
        // Reset orientation on disappear.
        .onDisappear {
            OrientationController.shared.resetOrientation()
        }
        // Detect tilt changes.
        .onChange(of: motionManager.pitch) { newPitch in
            guard !actionTaken && timerRunning && !showGameOver else { return }
            if UIDevice.current.orientation.isLandscape {
                if newPitch < -0.5 {
                    // Tilt down: Correct guess.
                    triggerHapticFeedback(style: .success)
                    score += 1
                    nextQuestion()
                } else if newPitch > 0.5 {
                    // Tilt up: Pass.
                    triggerHapticFeedback(style: .warning)
                    nextQuestion()
                }
            }
        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
    }
    
    private func nextQuestion() {
        actionTaken = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if currentIndex < randomizedTrashItems.count - 1 {
                currentIndex += 1
            } else {
                timerRunning = false
                showGameOver = true
            }
            actionTaken = false
        }
    }
}

// MARK: - Preview
struct HeadSupView_Previews: PreviewProvider {
    static var previews: some View {
        LandscapeView(content: HeadSupView())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
