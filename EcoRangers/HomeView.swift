import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            // Background image.
            Image("bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer(minLength: 20)
                
                // Title & Tagline Box
                VStack(spacing: 8) {
                    Text("EcoRangers")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.24))
                    
//                    Text("Join the cleanup drive and make a difference!")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                        .foregroundColor(Color(red: 0.10, green: 0.45, blue: 0.24).opacity(0.9))
//                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: 350, minHeight: 150)
                .background(Color.white.opacity(0.95))
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                
                // Button Box
                VStack(spacing: 16) {
                    NavigationLink(destination: ContentView()) {
                        Text("Clean up drive")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.10, green: 0.45, blue: 0.24))
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                    }
                    
                    NavigationLink(destination: HeadSupView()) {
                        Text("HeadSup")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.10, green: 0.45, blue: 0.24))
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                    }
                    
                    NavigationLink(destination: Rangers()) {
                        Text("Meet the Rangers")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.10, green: 0.45, blue: 0.24))
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                    }
                }
                .padding()
                .frame(maxWidth: 350, minHeight: 150)
                .background(Color.white.opacity(0.95))
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .navigationBarHidden(true)
    }
}

struct Rangers: View {
    var body: some View {
        VStack {
            Text("Meet the Rangers")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Add content or a list of rangers here.
            Text("This is the Rangers page. Add your ranger profiles or other content here!")
                .padding()
            
            Spacer()
        }
        .navigationTitle("Rangers")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
