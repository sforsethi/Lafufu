//
//  WishlistManager.swift
//  Lafufu
//
//  Comprehensive wishlist management system
//

import SwiftUI
import Foundation

enum WishlistPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case mustHave = "Must Have"
    
    var color: Color {
        switch self {
        case .low: return .gray
        case .medium: return .blue
        case .high: return .orange
        case .mustHave: return .red
        }
    }
    
    var systemImage: String {
        switch self {
        case .low: return "star"
        case .medium: return "star.fill"
        case .high: return "star.circle.fill"
        case .mustHave: return "heart.fill"
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .mustHave: return 0
        case .high: return 1
        case .medium: return 2
        case .low: return 3
        }
    }
}

struct WishlistItem: Identifiable, Codable {
    let id = UUID()
    let toyImageName: String
    let priority: WishlistPriority
    let dateAdded: Date
    let notes: String?
    let estimatedPrice: Double?
    let targetPurchaseDate: Date?
    
    init(toyImageName: String, priority: WishlistPriority = .medium, notes: String? = nil, estimatedPrice: Double? = nil, targetPurchaseDate: Date? = nil) {
        self.toyImageName = toyImageName
        self.priority = priority
        self.dateAdded = Date()
        self.notes = notes
        self.estimatedPrice = estimatedPrice
        self.targetPurchaseDate = targetPurchaseDate
    }
}

class WishlistManager: ObservableObject {
    @Published var wishlistItems: [WishlistItem] = []
    
    private let userDefaults = UserDefaults.standard
    private let wishlistKey = "com.lafufu.wishlist"
    private let collectionManager = UserCollectionManager.shared
    
    static let shared = WishlistManager()
    
    private init() {
        loadWishlist()
        
        // Listen for collection changes to auto-remove owned items from wishlist
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCollectionChange),
            name: .collectionUpdated,
            object: nil
        )
    }
    
    // MARK: - Core Wishlist Operations
    
    func addToWishlist(_ toyImageName: String, priority: WishlistPriority = .medium, notes: String? = nil, estimatedPrice: Double? = nil, targetDate: Date? = nil) {
        // Don't add if already owned or already in wishlist
        guard !collectionManager.isOwned(toyImageName),
              !isInWishlist(toyImageName) else {
            return
        }
        
        let item = WishlistItem(
            toyImageName: toyImageName,
            priority: priority,
            notes: notes,
            estimatedPrice: estimatedPrice,
            targetPurchaseDate: targetDate
        )
        
        wishlistItems.append(item)
        saveWishlist()
        HapticManager.notification(.success)
    }
    
    func removeFromWishlist(_ toyImageName: String) {
        wishlistItems.removeAll { $0.toyImageName == toyImageName }
        saveWishlist()
        HapticManager.impact(.medium)
    }
    
    func updateWishlistItem(_ itemId: UUID, priority: WishlistPriority? = nil, notes: String? = nil, estimatedPrice: Double? = nil, targetDate: Date? = nil) {
        guard let index = wishlistItems.firstIndex(where: { $0.id == itemId }) else { return }
        
        let currentItem = wishlistItems[index]
        let updatedItem = WishlistItem(
            toyImageName: currentItem.toyImageName,
            priority: priority ?? currentItem.priority,
            notes: notes ?? currentItem.notes,
            estimatedPrice: estimatedPrice ?? currentItem.estimatedPrice,
            targetPurchaseDate: targetDate ?? currentItem.targetPurchaseDate
        )
        
        wishlistItems[index] = updatedItem
        saveWishlist()
        HapticManager.selection()
    }
    
    func isInWishlist(_ toyImageName: String) -> Bool {
        return wishlistItems.contains { $0.toyImageName == toyImageName }
    }
    
    func getWishlistItem(for toyImageName: String) -> WishlistItem? {
        return wishlistItems.first { $0.toyImageName == toyImageName }
    }
    
    // MARK: - Analytics & Stats
    
    func getWishlistCount() -> Int {
        return wishlistItems.count
    }
    
    func getWishlistCount(for priority: WishlistPriority) -> Int {
        return wishlistItems.filter { $0.priority == priority }.count
    }
    
    func getTotalEstimatedValue() -> Double {
        return wishlistItems.compactMap { $0.estimatedPrice }.reduce(0, +)
    }
    
    func getUpcomingTargets(within days: Int = 30) -> [WishlistItem] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
        return wishlistItems.filter { item in
            if let targetDate = item.targetPurchaseDate {
                return targetDate <= cutoffDate && targetDate >= Date()
            }
            return false
        }.sorted { $0.targetPurchaseDate! < $1.targetPurchaseDate! }
    }
    
    func getWishlistByPriority() -> [WishlistPriority: [WishlistItem]] {
        return Dictionary(grouping: wishlistItems, by: { $0.priority })
    }
    
    func getWishlistBySeries() -> [String: [WishlistItem]] {
        let itemsWithSeries = wishlistItems.compactMap { item -> (String, WishlistItem)? in
            let seriesName = getSeriesName(for: item.toyImageName)
            return seriesName != "Unknown Series" ? (seriesName, item) : nil
        }
        return Dictionary(grouping: itemsWithSeries, by: { $0.0 }).mapValues { $0.map { $0.1 } }
    }
    
    // MARK: - Filtering & Sorting
    
    func getFilteredWishlist(priority: WishlistPriority? = nil, seriesName: String? = nil, withTargetDate: Bool? = nil, sortBy: WishlistSortOption = .priority) -> [WishlistItem] {
        var filtered = wishlistItems
        
        // Apply filters
        if let priority = priority {
            filtered = filtered.filter { $0.priority == priority }
        }
        
        if let seriesName = seriesName {
            filtered = filtered.filter { getSeriesName(for: $0.toyImageName) == seriesName }
        }
        
        if let withTargetDate = withTargetDate {
            filtered = filtered.filter { ($0.targetPurchaseDate != nil) == withTargetDate }
        }
        
        // Apply sorting
        switch sortBy {
        case .priority:
            filtered.sort { $0.priority.sortOrder < $1.priority.sortOrder }
        case .dateAdded:
            filtered.sort { $0.dateAdded > $1.dateAdded }
        case .targetDate:
            filtered.sort { (a, b) in
                guard let aDate = a.targetPurchaseDate else { return false }
                guard let bDate = b.targetPurchaseDate else { return true }
                return aDate < bDate
            }
        case .alphabetical:
            filtered.sort { getRelease(for: $0.toyImageName)?.name ?? "" < getRelease(for: $1.toyImageName)?.name ?? "" }
        case .estimatedPrice:
            filtered.sort { ($0.estimatedPrice ?? 0) > ($1.estimatedPrice ?? 0) }
        case .series:
            filtered.sort { getSeriesName(for: $0.toyImageName) < getSeriesName(for: $1.toyImageName) }
        }
        
        return filtered
    }
    
    // MARK: - Helper Functions
    
    private func getSeriesName(for toyImageName: String) -> String {
        for series in toySeries {
            if series.releases.contains(where: { $0.imageName == toyImageName }) {
                return series.name
            }
        }
        return "Unknown Series"
    }
    
    private func getRelease(for toyImageName: String) -> ToyRelease? {
        return toySeries.flatMap { $0.releases }.first { $0.imageName == toyImageName }
    }
    
    @objc private func handleCollectionChange() {
        // Remove items from wishlist if they're now owned
        let ownedItems = wishlistItems.filter { collectionManager.isOwned($0.toyImageName) }
        for item in ownedItems {
            removeFromWishlist(item.toyImageName)
        }
    }
    
    // MARK: - Persistence
    
    private func saveWishlist() {
        if let data = try? JSONEncoder().encode(wishlistItems) {
            userDefaults.set(data, forKey: wishlistKey)
        }
    }
    
    private func loadWishlist() {
        guard let data = userDefaults.data(forKey: wishlistKey),
              let items = try? JSONDecoder().decode([WishlistItem].self, from: data) else {
            return
        }
        wishlistItems = items
    }
    
    // MARK: - Bulk Operations
    
    func addMultipleToWishlist(_ toyImageNames: [String], priority: WishlistPriority = .medium) {
        let validItems = toyImageNames.filter { !collectionManager.isOwned($0) && !isInWishlist($0) }
        
        for imageName in validItems {
            let item = WishlistItem(toyImageName: imageName, priority: priority)
            wishlistItems.append(item)
        }
        
        saveWishlist()
        HapticManager.notification(.success)
    }
    
    func clearWishlist() {
        wishlistItems.removeAll()
        saveWishlist()
        HapticManager.notification(.warning)
    }
    
    func moveToCollection(_ itemId: UUID) {
        guard let item = wishlistItems.first(where: { $0.id == itemId }) else { return }
        
        // Add to collection
        collectionManager.toggleOwned(item.toyImageName)
        
        // Remove from wishlist
        removeFromWishlist(item.toyImageName)
        
        HapticManager.notification(.success)
    }
}

enum WishlistSortOption: String, CaseIterable {
    case priority = "Priority"
    case dateAdded = "Date Added"
    case targetDate = "Target Date"
    case alphabetical = "Alphabetical"
    case estimatedPrice = "Price"
    case series = "Series"
    
    var systemImage: String {
        switch self {
        case .priority: return "star.fill"
        case .dateAdded: return "clock.fill"
        case .targetDate: return "calendar.circle.fill"
        case .alphabetical: return "textformat.abc"
        case .estimatedPrice: return "dollarsign.circle.fill"
        case .series: return "folder.fill"
        }
    }
}

// MARK: - Notification Extensions

extension Notification.Name {
    static let collectionUpdated = Notification.Name("collectionUpdated")
    static let wishlistUpdated = Notification.Name("wishlistUpdated")
}