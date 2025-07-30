//
//  WishlistOptionsSheet.swift
//  Lafufu
//
//  Wishlist options sheet for adding items with details
//

import SwiftUI

struct WishlistOptionsSheet: View {
    let toyImageName: String
    @StateObject private var wishlistManager = WishlistManager.shared
    @State private var selectedPriority: WishlistPriority = .medium
    @State private var notes = ""
    @State private var estimatedPrice = ""
    @State private var targetDate: Date = Date()
    @State private var hasTargetDate = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    private var release: ToyRelease? {
        toySeries.flatMap { $0.releases }.first { $0.imageName == toyImageName }
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
                                    PriorityOptionCard(
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
                                DatePicker("Target Date", selection: $targetDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                            }
                        }
                    }
                }
                .padding(24)
            }
            .background(AppColors.background(for: colorScheme))
            .navigationTitle("Add to Wishlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent(for: colorScheme))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addToWishlist()
                    }
                    .foregroundColor(AppColors.accent(for: colorScheme))
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func addToWishlist() {
        let price = Double(estimatedPrice)
        let finalTargetDate = hasTargetDate ? targetDate : nil
        let finalNotes = notes.isEmpty ? nil : notes
        
        wishlistManager.addToWishlist(
            toyImageName,
            priority: selectedPriority,
            notes: finalNotes,
            estimatedPrice: price,
            targetDate: finalTargetDate
        )
        
        HapticManager.notification(.success)
        dismiss()
    }
}

struct PriorityOptionCard: View {
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
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}