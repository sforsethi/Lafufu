//
//  WishlistSupportingViews.swift
//  Lafufu
//
//  Supporting views for wishlist functionality
//

import SwiftUI

struct WishlistFiltersSheet: View {
    @Binding var selectedPriority: WishlistPriority?
    @Binding var selectedSeries: String?
    @Binding var sortOption: WishlistSortOption
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Priority Filter
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Priority")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(WishlistPriority.allCases, id: \.self) { priority in
                                PriorityFilterCard(
                                    priority: priority,
                                    isSelected: selectedPriority == priority
                                ) {
                                    selectedPriority = selectedPriority == priority ? nil : priority
                                    HapticManager.impact(.light)
                                }
                            }
                        }
                    }
                    
                    // Series Filter
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Series")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                        
                        VStack(spacing: 8) {
                            ForEach(toySeries, id: \.id) { series in
                                SeriesFilterRow(
                                    series: series,
                                    isSelected: selectedSeries == series.name
                                ) {
                                    selectedSeries = selectedSeries == series.name ? nil : series.name
                                    HapticManager.selection()
                                }
                            }
                        }
                    }
                    
                    // Sort Options
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Sort By")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(WishlistSortOption.allCases, id: \.self) { option in
                                SortOptionCard(
                                    option: option,
                                    isSelected: sortOption == option
                                ) {
                                    sortOption = option
                                    HapticManager.impact(.light)
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
                        selectedPriority = nil
                        selectedSeries = nil
                        sortOption = .priority
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

struct PriorityFilterCard: View {
    let priority: WishlistPriority
    let isSelected: Bool
    let onTap: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: priority.systemImage)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? .white : priority.color)
                
                Text(priority.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : AppColors.primaryText(for: colorScheme))
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? priority.color : AppColors.cardBackground(for: colorScheme)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? priority.color : Color.clear,
                        lineWidth: 2
                    )
            )
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SortOptionCard: View {
    let option: WishlistSortOption
    let isSelected: Bool
    let onTap: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: option.systemImage)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? .white : AppColors.accent(for: colorScheme))
                
                Text(option.rawValue)
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

struct AddToWishlistSheet: View {
    @StateObject private var wishlistManager = WishlistManager.shared
    @StateObject private var collectionManager = UserCollectionManager.shared
    @StateObject private var searchManager = SearchManager()
    @State private var selectedItems: Set<String> = []
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    private var availableItems: [ToyRelease] {
        let allReleases = toySeries.flatMap { $0.releases }
        return allReleases.filter { release in
            !collectionManager.isOwned(release.imageName) &&
            !wishlistManager.isInWishlist(release.imageName)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.secondaryText(for: colorScheme))
                    
                    TextField("Search toys to add...", text: $searchManager.searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.cardBackground(for: colorScheme))
                .cornerRadius(12)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Selection Info
                if !selectedItems.isEmpty {
                    HStack {
                        Text("\(selectedItems.count) items selected")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.accent(for: colorScheme))
                        
                        Spacer()
                        
                        Button("Clear Selection") {
                            selectedItems.removeAll()
                            HapticManager.selection()
                        }
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.accent(for: colorScheme))
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }
                
                // Items Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 16) {
                        ForEach(filteredItems, id: \.imageName) { release in
                            AddToWishlistItemCard(
                                release: release,
                                isSelected: selectedItems.contains(release.imageName)
                            ) {
                                toggleSelection(release.imageName)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }
            }
            .background(AppColors.background(for: colorScheme))
            .navigationTitle("Add to Wishlist")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent(for: colorScheme))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Selected") {
                        addSelectedItems()
                    }
                    .foregroundColor(AppColors.accent(for: colorScheme))
                    .fontWeight(.semibold)
                    .disabled(selectedItems.isEmpty)
                }
            }
        }
    }
    
    private var filteredItems: [ToyRelease] {
        if searchManager.searchText.isEmpty {
            return availableItems
        } else {
            return availableItems.filter { release in
                release.name.localizedCaseInsensitiveContains(searchManager.searchText) ||
                release.chineseName.localizedCaseInsensitiveContains(searchManager.searchText) ||
                release.description.localizedCaseInsensitiveContains(searchManager.searchText)
            }
        }
    }
    
    private func toggleSelection(_ imageName: String) {
        if selectedItems.contains(imageName) {
            selectedItems.remove(imageName)
        } else {
            selectedItems.insert(imageName)
        }
        HapticManager.selection()
    }
    
    private func addSelectedItems() {
        wishlistManager.addMultipleToWishlist(Array(selectedItems))
        dismiss()
    }
}

struct AddToWishlistItemCard: View {
    let release: ToyRelease
    let isSelected: Bool
    let onToggle: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: onToggle) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color(hex: release.color).opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(
                                    isSelected ? AppColors.accent(for: colorScheme) : Color(hex: release.color),
                                    lineWidth: isSelected ? 3 : 2
                                )
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
                    
                    if isSelected {
                        Circle()
                            .fill(AppColors.accent(for: colorScheme))
                            .frame(width: 20, height: 20)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .offset(x: 20, y: -20)
                    }
                }
                
                VStack(spacing: 2) {
                    Text(release.name)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppColors.primaryText(for: colorScheme))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    Text(release.chineseName)
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.secondaryText(for: colorScheme))
                        .lineLimit(1)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

struct EditWishlistItemSheet: View {
    let item: WishlistItem
    @StateObject private var wishlistManager = WishlistManager.shared
    @State private var selectedPriority: WishlistPriority
    @State private var notes: String
    @State private var estimatedPrice: String
    @State private var targetDate: Date?
    @State private var hasTargetDate: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    init(item: WishlistItem) {
        self.item = item
        _selectedPriority = State(initialValue: item.priority)
        _notes = State(initialValue: item.notes ?? "")
        _estimatedPrice = State(initialValue: item.estimatedPrice.map { String(format: "%.0f", $0) } ?? "")
        _targetDate = State(initialValue: item.targetPurchaseDate)
        _hasTargetDate = State(initialValue: item.targetPurchaseDate != nil)
    }
    
    private var release: ToyRelease? {
        toySeries.flatMap { $0.releases }.first { $0.imageName == item.toyImageName }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Toy Info
                    if let release = release {
                        VStack(spacing: 12) {
                            Circle()
                                .fill(Color(hex: release.color).opacity(0.2))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Circle()
                                        .stroke(Color(hex: release.color), lineWidth: 3)
                                )
                                .overlay(
                                    VStack(spacing: 2) {
                                        HStack(spacing: 3) {
                                            Circle().fill(Color.black).frame(width: 4, height: 4)
                                            Circle().fill(Color.black).frame(width: 4, height: 4)
                                        }
                                        Capsule().fill(Color.black).frame(width: 12, height: 2)
                                    }
                                )
                            
                            VStack(spacing: 4) {
                                Text(release.name)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(AppColors.primaryText(for: colorScheme))
                                
                                Text(release.chineseName)
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.secondaryText(for: colorScheme))
                            }
                        }
                    }
                    
                    VStack(spacing: 20) {
                        // Priority Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Priority")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.primaryText(for: colorScheme))
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(WishlistPriority.allCases, id: \.self) { priority in
                                    PriorityFilterCard(
                                        priority: priority,
                                        isSelected: selectedPriority == priority
                                    ) {
                                        selectedPriority = priority
                                        HapticManager.impact(.light)
                                    }
                                }
                            }
                        }
                        
                        // Notes
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.primaryText(for: colorScheme))
                            
                            TextField("Add notes about this item...", text: $notes, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(3...6)
                        }
                        
                        // Estimated Price
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Estimated Price")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.primaryText(for: colorScheme))
                            
                            TextField("Price (optional)", text: $estimatedPrice)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                        
                        // Target Date
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Set Target Purchase Date", isOn: $hasTargetDate)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppColors.primaryText(for: colorScheme))
                            
                            if hasTargetDate {
                                DatePicker("Target Date", selection: Binding(
                                    get: { targetDate ?? Date() },
                                    set: { targetDate = $0 }
                                ), displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                            }
                        }
                    }
                }
                .padding(24)
            }
            .background(AppColors.background(for: colorScheme))
            .navigationTitle("Edit Wishlist Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent(for: colorScheme))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .foregroundColor(AppColors.accent(for: colorScheme))
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func saveChanges() {
        let price = Double(estimatedPrice)
        let finalTargetDate = hasTargetDate ? targetDate : nil
        let finalNotes = notes.isEmpty ? nil : notes
        
        wishlistManager.updateWishlistItem(
            item.id,
            priority: selectedPriority,
            notes: finalNotes,
            estimatedPrice: price,
            targetDate: finalTargetDate
        )
        
        dismiss()
    }
}