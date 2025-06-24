//
//  CollectionView.swift
//  Lafufu
//
//  Created by Raghav Sethi on 21/06/25.
//

import SwiftUI

struct CollectionView: View {
    @StateObject private var collectionManager = UserCollectionManager.shared
    @State private var showingShareCard = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Text("My Collection")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    showingShareCard = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Share")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            
            // Collection stats
            HStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("\(collectionManager.getOwnedCount())")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.green)
                        .contentTransition(.numericText())
                    Text("Owned")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 4) {
                    Text("\(collectionManager.getFavoritesCount())")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.red)
                        .contentTransition(.numericText())
                    Text("Favorites")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 4) {
                    Text("\(String(format: "%.1f", collectionManager.getCompletionPercentage()))%")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.blue)
                        .contentTransition(.numericText())
                    Text("Complete")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .animation(.easeInOut(duration: 0.3), value: collectionManager.getOwnedCount())
            .animation(.easeInOut(duration: 0.3), value: collectionManager.getFavoritesCount())
            
            ScrollView {
                VStack(spacing: 24) {
                    // Owned Items Collection
                    CollectionStackView(
                        title: "Owned Items",
                        count: collectionManager.getOwnedCount(),
                        items: getOwnedReleases(),
                        color: .green,
                        icon: "checkmark.circle.fill"
                    )
                    
                    // Favorites Collection
                    CollectionStackView(
                        title: "Favorites",
                        count: collectionManager.getFavoritesCount(),
                        items: getFavoriteReleases(),
                        color: .red,
                        icon: "heart.fill"
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            // Force refresh data when view appears
            collectionManager.refreshData()
        }
        .sheet(isPresented: $showingShareCard) {
            ShareCardGeneratorView()
        }
    }
    
    private func getOwnedReleases() -> [ToyRelease] {
        let allReleases = getAllReleases()
        print("DEBUG: All available imageNames: \(allReleases.map { $0.imageName })")
        print("DEBUG: Stored owned items: \(collectionManager.getStoredOwnedItems())")
        
        let ownedReleases = allReleases.filter { release in
            let isOwned = collectionManager.isOwned(release.imageName)
            if isOwned {
                print("DEBUG: Found matching owned item: \(release.imageName)")
            }
            return isOwned
        }
        print("DEBUG: Owned releases count: \(ownedReleases.count)")
        print("DEBUG: Owned releases: \(ownedReleases.map { $0.imageName })")
        return ownedReleases
    }
    
    private func getFavoriteReleases() -> [ToyRelease] {
        let favoriteReleases = getAllReleases().filter { release in
            collectionManager.isFavorite(release.imageName)
        }
        print("DEBUG: Favorite releases count: \(favoriteReleases.count)")
        print("DEBUG: Favorite releases: \(favoriteReleases.map { $0.imageName })")
        return favoriteReleases
    }
    
    private func getAllReleases() -> [ToyRelease] {
        return toySeries.flatMap { $0.releases }
    }
}

struct CollectionStackView: View {
    let title: String
    let count: Int
    let items: [ToyRelease]
    let color: Color
    let icon: String
    @State private var showingDetailList = false
    @StateObject private var collectionManager = UserCollectionManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            // Horizontal collection display
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(height: 160)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                if items.isEmpty {
                    // Empty state
                    VStack(spacing: 12) {
                        Image(systemName: icon)
                            .font(.system(size: 40))
                            .foregroundColor(color.opacity(0.3))
                        
                        Text("No items yet")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                } else {
                    // Horizontal layout with items
                    HStack(spacing: 8) {
                        // Show first 2-3 items
                        ForEach(Array(items.prefix(2).enumerated()), id: \.offset) { index, release in
                            MiniReleaseCard(release: release)
                        }
                        
                        // Show "+X more" card if there are more than 2 items
                        if items.count > 2 {
                            MoreItemsCard(
                                count: items.count - 2,
                                color: color
                            )
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
            }
            .onTapGesture {
                if !items.isEmpty {
                    showingDetailList = true
                }
            }
            .animation(.easeInOut(duration: 0.3), value: items.count)
            
            // Collection info
            VStack(spacing: 4) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(color)
                    
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                
                HStack {
                    Text("\(count) items")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .contentTransition(.numericText())
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingDetailList) {
            CollectionDetailListView(title: title, items: items, color: color, icon: icon)
        }
        .id(items.count)
    }
}

struct MiniReleaseCard: View {
    let release: ToyRelease
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: release.color).opacity(0.2))
                    .frame(width: 80, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: release.color).opacity(0.4), lineWidth: 1)
                    )
                
                VStack(spacing: 6) {
                    // Mini character representation
                    Circle()
                        .fill(Color(hex: release.color).opacity(0.6))
                        .frame(width: 32, height: 32)
                        .overlay(
                            VStack(spacing: 1) {
                                HStack(spacing: 3) {
                                    Circle().fill(Color.black).frame(width: 3, height: 3)
                                    Circle().fill(Color.black).frame(width: 3, height: 3)
                                }
                                Capsule().fill(Color.black).frame(width: 8, height: 1)
                            }
                        )
                    
                    Text(release.name)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                }
            }
        }
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct MoreItemsCard: View {
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.1))
                    .frame(width: 80, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
                
                VStack(spacing: 8) {
                    // Plus icon
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(color.opacity(0.7))
                    
                    Text("+\(count)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(color)
                    
                    Text("more")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
        }
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct CollectionDetailListView: View {
    let title: String
    let items: [ToyRelease]
    let color: Color
    let icon: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 20) {
                    ForEach(items) { release in
                        ReleaseItemView(release: release)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
            }
            .background(Color(hex: "F3F4F6"))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(color)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}


