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
    @State private var showingSortOptions = false
    @State private var sortOption: SortOption = .alphabetical
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Text("My Collection")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText(for: colorScheme))
                
                Spacer()
                
                // Sort Button
                Button(action: {
                    showingSortOptions = true
                    HapticManager.impact(.light)
                }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.accent(for: colorScheme))
                        .frame(width: 40, height: 40)
                        .background(AppColors.cardBackground(for: colorScheme))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                // Share Button
                Button(action: {
                    showingShareCard = true
                    HapticManager.impact(.medium)
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
                    .background(AppColors.gradient(for: colorScheme))
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
        .background(AppColors.background(for: colorScheme))
        .sheet(isPresented: $showingShareCard) {
            EnhancedShareCardGenerator()
        }
        .actionSheet(isPresented: $showingSortOptions) {
            ActionSheet(
                title: Text("Sort Collection"),
                buttons: SortOption.allCases.map { option in
                    .default(Text(option.rawValue)) {
                        sortOption = option
                        HapticManager.selection()
                    }
                } + [.cancel()]
            )
        }
    }
    
    private func getOwnedReleases() -> [ToyRelease] {
        let allReleases = getAllReleases()
        var ownedReleases = allReleases.filter { release in
            collectionManager.isOwned(release.imageName)
        }
        
        // Apply sorting
        ownedReleases = applySorting(to: ownedReleases)
        return ownedReleases
    }
    
    private func getFavoriteReleases() -> [ToyRelease] {
        var favoriteReleases = getAllReleases().filter { release in
            collectionManager.isFavorite(release.imageName)
        }
        
        // Apply sorting
        favoriteReleases = applySorting(to: favoriteReleases)
        return favoriteReleases
    }
    
    private func applySorting(to releases: [ToyRelease]) -> [ToyRelease] {
        var sortedReleases = releases
        
        switch sortOption {
        case .alphabetical:
            sortedReleases.sort { $0.name < $1.name }
        case .series:
            sortedReleases.sort { getSeriesName(for: $0) < getSeriesName(for: $1) }
        case .color:
            sortedReleases.sort { $0.color < $1.color }
        case .recent:
            // For now, sort by name as we don't have creation dates
            sortedReleases.sort { $0.name > $1.name }
        case .owned:
            sortedReleases.sort { (a, b) in
                let aOwned = collectionManager.isOwned(a.imageName)
                let bOwned = collectionManager.isOwned(b.imageName)
                if aOwned == bOwned {
                    return a.name < b.name
                }
                return aOwned && !bOwned
            }
        case .favorites:
            sortedReleases.sort { (a, b) in
                let aFav = collectionManager.isFavorite(a.imageName)
                let bFav = collectionManager.isFavorite(b.imageName)
                if aFav == bFav {
                    return a.name < b.name
                }
                return aFav && !bFav
            }
        }
        
        return sortedReleases
    }
    
    private func getSeriesName(for release: ToyRelease) -> String {
        for series in toySeries {
            if series.releases.contains(where: { $0.imageName == release.imageName }) {
                return series.name
            }
        }
        return "Unknown Series"
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


