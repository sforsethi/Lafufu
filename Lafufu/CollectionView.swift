//
//  CollectionView.swift
//  Lafufu
//
//  Created by Raghav Sethi on 21/06/25.
//
import SwiftUI

struct CollectionView: View {
    @StateObject private var collectionManager = UserCollectionManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Text("My Collection")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            
            // Collection stats
            HStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("\(collectionManager.getOwnedCount())")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.green)
                    Text("Owned")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 4) {
                    Text("\(collectionManager.getFavoritesCount())")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.red)
                    Text("Favorites")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 4) {
                    Text("\(String(format: "%.1f", collectionManager.getCompletionPercentage()))%")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.blue)
                    Text("Complete")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            // Collection grid
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 24) {
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
            
            Spacer()
        }
    }
    
    private func getOwnedReleases() -> [LabubuRelease] {
        return getAllReleases().filter { release in
            collectionManager.isOwned(release.id.uuidString)
        }
    }
    
    private func getFavoriteReleases() -> [LabubuRelease] {
        return getAllReleases().filter { release in
            collectionManager.isFavorite(release.id.uuidString)
        }
    }
    
    private func getAllReleases() -> [LabubuRelease] {
        return labubuSeries.flatMap { $0.releases }
    }
}

struct CollectionStackView: View {
    let title: String
    let count: Int
    let items: [LabubuRelease]
    let color: Color
    let icon: String
    @State private var showingDetailList = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Stack of items with tilted effect
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
                    // Stacked items with tilt effect
                    ForEach(Array(items.prefix(3).enumerated()), id: \.offset) { index, release in
                        MiniReleaseCard(release: release)
                            .rotationEffect(.degrees(Double(index - 1) * 8))
                            .offset(
                                x: CGFloat(index - 1) * 8,
                                y: CGFloat(index) * -4
                            )
                            .scaleEffect(1.0 - CGFloat(index) * 0.05)
                            .zIndex(Double(3 - index))
                    }
                    
                    // Show count if more than 3 items
                    if items.count > 3 {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("+\(items.count - 3)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(color)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(12)
                        .zIndex(10)
                    }
                }
            }
            .onTapGesture {
                if !items.isEmpty {
                    showingDetailList = true
                }
            }
            
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
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingDetailList) {
            CollectionDetailListView(title: title, items: items, color: color, icon: icon)
        }
    }
}

struct MiniReleaseCard: View {
    let release: LabubuRelease
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: release.color).opacity(0.2))
                .frame(width: 80, height: 100)
            
            VStack(spacing: 4) {
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
}

struct CollectionDetailListView: View {
    let title: String
    let items: [LabubuRelease]
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
