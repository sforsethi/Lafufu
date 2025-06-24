import SwiftUI

struct ToyRelease: Identifiable {
    let id = UUID()
    let name: String
    let chineseName: String
    let imageName: String
    let color: String
    let description: String
}

struct ToySeries: Identifiable {
    let id = UUID()
    let name: String
    let chineseName: String
    let releases: [ToyRelease]
    let color: String
    let description: String
}

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                VStack(spacing: 0) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "E8E3F5"))
                                .frame(width: 60, height: 60)
                            
                            Text("🦔")
                                .font(.system(size: 28))
                        }
                        
                        Spacer()
                        
                        // Title with user name
                        VStack(spacing: 2) {
                            if let userName = UserDefaults.standard.string(forKey: "userName") {
                                Text("Hi, \(userName)!")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            Text("Explore Series")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
 
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    ExploreView()
                }
                .background(Color(hex: "F0F0F0"))
            }
            .tabItem {
                Image(systemName: "safari")
                Text("Explore")
            }
            
            NavigationView {
                VStack(spacing: 0) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "E8E3F5"))
                                .frame(width: 60, height: 60)
                            
                            Text("🦔")
                                .font(.system(size: 28))
                        }
                        
                        Spacer()
                        
                        // Title with user name
                        VStack(spacing: 2) {
                            if let userName = UserDefaults.standard.string(forKey: "userName") {
                                Text("Hi, \(userName)!")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            Text("My Collection")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    CollectionView()
                }
                .background(Color(hex: "F0F0F0"))
            }
            .tabItem {
                Image(systemName: "heart.circle")
                Text("My Collection")
            }
        }
        .accentColor(.black)
        .ignoresSafeArea(.all)
    }
}

 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
