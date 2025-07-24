//
//  SearchComponents.swift
//  Lafufu
//
//  Supporting components for enhanced search and filtering
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let systemImage: String
    let onRemove: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: systemImage)
                .font(.system(size: 10))
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .lineLimit(1)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 12))
            }
        }
        .foregroundColor(AppColors.accent(for: colorScheme))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(AppColors.accent(for: colorScheme).opacity(0.1))
        .cornerRadius(12)
    }
}

struct FilterSheet: View {
    @ObservedObject var searchManager: SearchManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Sort Options
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Sort By")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                OptionCard(
                                    title: option.rawValue,
                                    systemImage: option.systemImage,
                                    isSelected: searchManager.sortOption == option
                                ) {
                                    searchManager.sortOption = option
                                    HapticManager.impact(.light)
                                }
                            }
                        }
                    }
                    
                    // Filter Options
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Filter By")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(FilterOption.allCases, id: \.self) { option in
                                OptionCard(
                                    title: option.rawValue,
                                    systemImage: option.systemImage,
                                    isSelected: searchManager.filterOption == option
                                ) {
                                    searchManager.filterOption = option
                                    HapticManager.impact(.light)
                                }
                            }
                        }
                    }
                    
                    // Series Selection
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Series")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                        
                        VStack(spacing: 8) {
                            ForEach(toySeries, id: \.id) { series in
                                SeriesFilterRow(
                                    series: series,
                                    isSelected: searchManager.selectedSeries.contains(series.name)
                                ) {
                                    if searchManager.selectedSeries.contains(series.name) {
                                        searchManager.selectedSeries.remove(series.name)
                                    } else {
                                        searchManager.selectedSeries.insert(series.name)
                                    }
                                    HapticManager.selection()
                                }
                            }
                        }
                    }
                }
                .padding(24)
            }
            .background(AppColors.background(for: colorScheme))
            .navigationTitle("Filters & Sorting")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear All") {
                        searchManager.clearFilters()
                        HapticManager.impact(.medium)
                    }
                    .foregroundColor(AppColors.accent(for: colorScheme))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent(for: colorScheme))
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct OptionCard: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let onTap: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? .white : AppColors.accent(for: colorScheme))
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : AppColors.primaryText(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? AppColors.accent(for: colorScheme) : AppColors.cardBackground(for: colorScheme)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? AppColors.accent(for: colorScheme) : Color.clear,
                        lineWidth: 2
                    )
            )
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SeriesFilterRow: View {
    let series: ToySeries
    let isSelected: Bool
    let onTap: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    private let collectionManager = UserCollectionManager.shared
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Series Color Indicator
                Circle()
                    .fill(Color(hex: series.color))
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(series.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.primaryText(for: colorScheme))
                    
                    HStack(spacing: 8) {
                        Text("\(series.releases.count) items")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.secondaryText(for: colorScheme))
                        
                        let ownedCount = series.releases.filter { collectionManager.isOwned($0.imageName) }.count
                        if ownedCount > 0 {
                            Text("• \(ownedCount) owned")
                                .font(.system(size: 12))
                                .foregroundColor(.green)
                        }
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.accent(for: colorScheme))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground(for: colorScheme))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? AppColors.accent(for: colorScheme) : Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptySearchView: View {
    let searchText: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(AppColors.secondaryText(for: colorScheme).opacity(0.5))
            
            VStack(spacing: 8) {
                Text(searchText.isEmpty ? "No items found" : "No results for \"\(searchText)\"")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryText(for: colorScheme))
                
                Text(searchText.isEmpty ? "Try adjusting your filters" : "Try a different search term or adjust your filters")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText(for: colorScheme))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

struct CompactReleaseCard: View {
    let release: ToyRelease
    @State private var showingDetail = false
    @Environment(\.colorScheme) var colorScheme
    
    private let collectionManager = UserCollectionManager.shared
    private let photoManager = PhotoManager()
    
    var body: some View {
        Button(action: {
            showingDetail = true
            HapticManager.impact(.light)
        }) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: release.color).opacity(0.1))
                        .frame(height: 120)
                    
                    // Show user photo if available
                    if let mainPhoto = photoManager.getMainPhoto(for: release.imageName),
                       let image = photoManager.loadImage(for: mainPhoto) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        // Mini character representation
                        VStack(spacing: 4) {
                            Circle()
                                .fill(Color(hex: release.color).opacity(0.6))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    VStack(spacing: 1) {
                                        HStack(spacing: 3) {
                                            Circle().fill(Color.black).frame(width: 3, height: 3)
                                            Circle().fill(Color.black).frame(width: 3, height: 3)
                                        }
                                        Capsule().fill(Color.black).frame(width: 8, height: 1)
                                    }
                                )
                        }
                    }
                    
                    // Status indicators
                    VStack {
                        HStack {
                            Spacer()
                            VStack(spacing: 4) {
                                if collectionManager.isOwned(release.imageName) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.green)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                }
                                
                                if collectionManager.isFavorite(release.imageName) {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.red)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(8)
                }
                
                VStack(spacing: 2) {
                    Text(release.name)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppColors.primaryText(for: colorScheme))
                        .lineLimit(1)
                    
                    Text(release.chineseName)
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.secondaryText(for: colorScheme))
                        .lineLimit(1)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            ToyDetailView(release: release)
        }
    }
}