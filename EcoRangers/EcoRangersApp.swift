import SwiftUI

@main
struct EcoRangersApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(StackNavigationViewStyle()) // For better iPhone compatibility
        }
    }
}
