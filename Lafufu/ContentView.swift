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
            ExploreView()
            .tabItem {
                Image(systemName: "safari")
                Text("Explore")
            }
            
            CollectionView()
            .tabItem {
                Image(systemName: "heart.circle")
                Text("Collection")
            }
            
            WishlistView()
            .tabItem {
                Image(systemName: "star.circle")
                Text("Wishlist")
            }
        }
        .accentColor(.black)
        .ignoresSafeArea(.all)
        .handleDeepLinks()
    }
}

 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
