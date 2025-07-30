//
//  WishlistViews.swift
//  Lafufu
//
//  Comprehensive wishlist UI components
//

import SwiftUI

struct WishlistView: View {
    @StateObject private var wishlistManager = WishlistManager.shared
    @StateObject private var searchManager = SearchManager()
    @State private var selectedPriority: WishlistPriority?
    @State private var selectedSeries: String?
    @State private var sortOption: WishlistSortOption = .priority
    @State private var showingFilters = false
    @State private var showingAddItems = false
    @Environment(\.colorScheme) var colorScheme
    
    var filteredWishlist: [WishlistItem] {
        wishlistManager.getFilteredWishlist(
            priority: selectedPriority,
            seriesName: selectedSeries,
            sortBy: sortOption
        )
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with stats
                wishlistHeader
                
                // Filters and sorting
                if hasActiveFilters {
                    activeFiltersView
                }
                
                // Content
                if wishlistManager.wishlistItems.isEmpty {
                    emptyWishlistView
                } else {
                    wishlistContent
                }
            }
            .background(AppColors.background(for: colorScheme))
            .navigationTitle("Wishlist")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    sortButton
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        filterButton
                        addButton
                    }
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            WishlistFiltersSheet(
                selectedPriority: $selectedPriority,
                selectedSeries: $selectedSeries,
                sortOption: $sortOption
            )
        }
        .sheet(isPresented: $showingAddItems) {
            AddToWishlistSheet()
        }
    }
    
    // MARK: - Header
    
    private var wishlistHeader: some View {
        VStack(spacing: 16) {
            // Stats Cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    WishlistStatCard(
                        title: "Total Items",
                        value: "\(wishlistManager.getWishlistCount())",
                        color: .blue,
                        icon: "list.bullet.circle.fill"
                    )
                    
                    WishlistStatCard(
                        title: "Must Have",
                        value: "\(wishlistManager.getWishlistCount(for: .mustHave))",
                        color: .red,
                        icon: "heart.fill"
                    )
                    
                    WishlistStatCard(
                        title: "High Priority",
                        value: "\(wishlistManager.getWishlistCount(for: .high))",
                        color: .orange,
                        icon: "star.circle.fill"
                    )
                    
                    let totalValue = wishlistManager.getTotalEstimatedValue()
                    if totalValue > 0 {
                        WishlistStatCard(
                            title: "Est. Value",
                            value: "$\(String(format: "%.0f", totalValue))",
                            color: .green,
                            icon: "dollarsign.circle.fill"
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
            
            // Upcoming targets
            let upcomingTargets = wishlistManager.getUpcomingTargets()
            if !upcomingTargets.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "calendar.circle.fill")
                            .foregroundColor(.orange)
                        Text("Upcoming Targets")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                        Spacer()
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(upcomingTargets.prefix(5), id: \.id) { item in
                                UpcomingTargetCard(item: item)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.vertical, 16)
        .background(AppColors.background(for: colorScheme))
    }
    
    // MARK: - Filters
    
    private var hasActiveFilters: Bool {
        selectedPriority != nil || selectedSeries != nil || sortOption != .priority
    }
    
    private var activeFiltersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if let priority = selectedPriority {
                    FilterChip(
                        title: priority.rawValue,
                        systemImage: priority.systemImage
                    ) {
                        selectedPriority = nil
                    }
                }
                
                if let series = selectedSeries {
                    FilterChip(
                        title: series,
                        systemImage: "folder"
                    ) {
                        selectedSeries = nil
                    }
                }
                
                if sortOption != .priority {
                    FilterChip(
                        title: "Sort: \(sortOption.rawValue)",
                        systemImage: sortOption.systemImage
                    ) {
                        sortOption = .priority
                    }
                }
                
                Button("Clear All") {
                    selectedPriority = nil
                    selectedSeries = nil
                    sortOption = .priority
                    HapticManager.impact(.medium)
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppColors.accent(for: colorScheme))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.accent(for: colorScheme).opacity(0.1))
                .cornerRadius(16)
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Content
    
    private var wishlistContent: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredWishlist, id: \.id) { item in
                    WishlistItemCard(item: item)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
    }
    
    private var emptyWishlistView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "heart.circle")
                    .font(.system(size: 64))
                    .foregroundColor(AppColors.secondaryText(for: colorScheme).opacity(0.5))
                
                VStack(spacing: 8) {
                    Text("Your Wishlist is Empty")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(AppColors.primaryText(for: colorScheme))
                    
                    Text("Start adding toys you want to collect!")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.secondaryText(for: colorScheme))
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    showingAddItems = true
                    HapticManager.impact(.medium)
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Items to Wishlist")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.gradient(for: colorScheme))
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Toolbar Buttons
    
    private var sortButton: some View {
        Menu {
            ForEach(WishlistSortOption.allCases, id: \.self) { option in
                Button(action: {
                    sortOption = option
                    HapticManager.selection()
                }) {
                    HStack {
                        Text(option.rawValue)
                        if sortOption == option {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down.circle")
                .font(.system(size: 20))
                .foregroundColor(AppColors.accent(for: colorScheme))
        }
    }
    
    private var filterButton: some View {
        Button(action: {
            showingFilters = true
            HapticManager.impact(.light)
        }) {
            ZStack {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 20))
                    .foregroundColor(hasActiveFilters ? AppColors.accent(for: colorScheme) : AppColors.secondaryText(for: colorScheme))
                
                if hasActiveFilters {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: 6, y: -6)
                }
            }
        }
    }
    
    private var addButton: some View {
        Button(action: {
            showingAddItems = true
            HapticManager.impact(.medium)
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(AppColors.accent(for: colorScheme))
        }
    }
}

// MARK: - Supporting Views

struct WishlistStatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(AppColors.primaryText(for: colorScheme))
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppColors.secondaryText(for: colorScheme))
        }
        .frame(width: 80, height: 80)
        .background(AppColors.cardBackground(for: colorScheme))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct UpcomingTargetCard: View {
    let item: WishlistItem
    @Environment(\.colorScheme) var colorScheme
    
    private var release: ToyRelease? {
        toySeries.flatMap { $0.releases }.first { $0.imageName == item.toyImageName }
    }
    
    private var daysUntilTarget: Int {
        guard let targetDate = item.targetPurchaseDate else { return 0 }
        return Calendar.current.dateComponents([.day], from: Date(), to: targetDate).day ?? 0
    }
    
    var body: some View {
        VStack(spacing: 6) {
            if let release = release {
                Circle()
                    .fill(Color(hex: release.color))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Text(String(release.name.prefix(1)))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                Text(release.name)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(AppColors.primaryText(for: colorScheme))
                    .lineLimit(1)
                
                Text("\(daysUntilTarget) days")
                    .font(.system(size: 9))
                    .foregroundColor(.orange)
            }
        }
        .frame(width: 60)
        .padding(.vertical, 8)
        .background(AppColors.cardBackground(for: colorScheme))
        .cornerRadius(12)
    }
}

struct WishlistItemCard: View {
    let item: WishlistItem
    @StateObject private var wishlistManager = WishlistManager.shared
    @State private var showingDetail = false
    @State private var showingEditSheet = false
    @Environment(\.colorScheme) var colorScheme
    
    private var release: ToyRelease? {
        toySeries.flatMap { $0.releases }.first { $0.imageName == item.toyImageName }
    }
    
    private var seriesName: String {
        for series in toySeries {
            if series.releases.contains(where: { $0.imageName == item.toyImageName }) {
                return series.name
            }
        }
        return "Unknown Series"
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Toy Image/Icon
            if let release = release {
                Circle()
                    .fill(Color(hex: release.color).opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(Color(hex: release.color), lineWidth: 2)
                    )
                    .overlay(
                        VStack(spacing: 1) {
                            HStack(spacing: 2) {
                                Circle().fill(Color.black).frame(width: 3, height: 3)
                                Circle().fill(Color.black).frame(width: 3, height: 3)
                            }
                            Capsule().fill(Color.black).frame(width: 8, height: 1)
                        }
                    )
                    .onTapGesture {
                        showingDetail = true
                        HapticManager.impact(.light)
                    }
            }
            
            // Item Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    if let release = release {
                        Text(release.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                    }
                    
                    Spacer()
                    
                    // Priority Badge
                    HStack(spacing: 4) {
                        Image(systemName: item.priority.systemImage)
                            .font(.system(size: 10))
                        Text(item.priority.rawValue)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(item.priority.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(item.priority.color.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Text(seriesName)
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.secondaryText(for: colorScheme))
                
                if let notes = item.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondaryText(for: colorScheme))
                        .lineLimit(2)
                }
                
                HStack(spacing: 12) {
                    if let price = item.estimatedPrice {
                        Text("$\(String(format: "%.0f", price))")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }
                    
                    if let targetDate = item.targetPurchaseDate {
                        Text(targetDate, style: .date)
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                    Text(item.dateAdded, style: .relative)
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.secondaryText(for: colorScheme))
                }
            }
            
            // Action Menu
            Menu {
                Button("Edit") {
                    showingEditSheet = true
                }
                
                Button("Move to Collection") {
                    wishlistManager.moveToCollection(item.id)
                }
                
                Button("Remove from Wishlist", role: .destructive) {
                    wishlistManager.removeFromWishlist(item.toyImageName)
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.secondaryText(for: colorScheme))
            }
        }
        .padding(16)
        .background(AppColors.cardBackground(for: colorScheme))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .sheet(isPresented: $showingDetail) {
            if let release = release {
                ToyDetailView(release: release)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditWishlistItemSheet(item: item)
        }
    }
}