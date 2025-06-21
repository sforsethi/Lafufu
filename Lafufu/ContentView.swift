import SwiftUI

// MARK: - Labubu Release Model
struct LabubuRelease: Identifiable {
    let id = UUID()
    let name: String
    let chineseName: String
    let imageName: String
    let color: String
    let description: String
}

// MARK: - Labubu Series Model
struct LabubuSeries: Identifiable {
    let id = UUID()
    let name: String
    let chineseName: String
    let releases: [LabubuRelease]
    let color: String
    let description: String
}

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                VStack(spacing: 0) {
                    // Status bar area
                    Color.clear
                        .frame(height: 44)
                    
                    // Top header with app icon, title, and search
                    HStack {
                        // App icon - circular with Labubu face
                        ZStack {
                            Circle()
                                .fill(Color(hex: "E8E3F5"))
                                .frame(width: 60, height: 60)
                            
                            // Labubu face emoji/icon
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
                            Text("Toy Collector")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        // Search button
                        Button {
                            // Search action
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "F5F5F5"))
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    CollectionView()
                }
                .background(Color(hex: "F0F0F0"))
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            NavigationView {
                VStack(spacing: 0) {
                    // Status bar area
                    Color.clear
                        .frame(height: 44)
                    
                    // Top header with app icon, title, and search
                    HStack {
                        // App icon - circular with Labubu face
                        ZStack {
                            Circle()
                                .fill(Color(hex: "E8E3F5"))
                                .frame(width: 60, height: 60)
                            
                            // Labubu face emoji/icon
                            Text("🦔")
                                .font(.system(size: 28))
                        }
                        
                        Spacer()
                        
                        // Title
                        Text("Explore Series")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        // Search button
                        Button {
                            // Search action
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "F5F5F5"))
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 22, weight: .medium))
                                    .foregroundColor(.black)
                            }
                        }
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
