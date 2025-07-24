//
//  SearchManager.swift
//  Lafufu
//
//  Advanced search and filtering system
//

import SwiftUI
import Combine

enum SortOption: String, CaseIterable {
    case alphabetical = "Alphabetical"
    case series = "By Series"
    case color = "By Color"
    case recent = "Recently Added"
    case owned = "Owned First"
    case favorites = "Favorites First"
    
    var systemImage: String {
        switch self {
        case .alphabetical: return "textformat.abc"
        case .series: return "folder"
        case .color: return "paintpalette"
        case .recent: return "clock"
        case .owned: return "checkmark.circle"
        case .favorites: return "heart"
        }
    }
}

enum FilterOption: String, CaseIterable {
    case all = "All Items"
    case owned = "Owned Only"
    case notOwned = "Not Owned"
    case favorites = "Favorites Only"
    case withPhotos = "With Photos"
    case withoutPhotos = "Without Photos"
    
    var systemImage: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .owned: return "checkmark.circle.fill"
        case .notOwned: return "circle"
        case .favorites: return "heart.fill"
        case .withPhotos: return "photo.fill"
        case .withoutPhotos: return "photo"
        }
    }
}

class SearchManager: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedSeries: Set<String> = []
    @Published var sortOption: SortOption = .alphabetical
    @Published var filterOption: FilterOption = .all
    @Published var showingFilters: Bool = false
    
    private let collectionManager = UserCollectionManager.shared
    
    func filteredAndSortedReleases() -> [ToyRelease] {
        let allReleases = toySeries.flatMap { $0.releases }
        
        // Apply text search
        var filtered = allReleases
        if !searchText.isEmpty {
            filtered = filtered.filter { release in
                release.name.localizedCaseInsensitiveContains(searchText) ||
                release.chineseName.localizedCaseInsensitiveContains(searchText) ||
                release.description.localizedCaseInsensitiveContains(searchText) ||
                getSeriesName(for: release).localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply series filter
        if !selectedSeries.isEmpty {
            filtered = filtered.filter { release in
                selectedSeries.contains(getSeriesName(for: release))
            }
        }
        
        // Apply filter option
        switch filterOption {
        case .all:
            break
        case .owned:
            filtered = filtered.filter { collectionManager.isOwned($0.imageName) }
        case .notOwned:
            filtered = filtered.filter { !collectionManager.isOwned($0.imageName) }
        case .favorites:
            filtered = filtered.filter { collectionManager.isFavorite($0.imageName) }
        case .withPhotos:
            filtered = filtered.filter { collectionManager.hasOwnedImage($0.imageName) }
        case .withoutPhotos:
            filtered = filtered.filter { !collectionManager.hasOwnedImage($0.imageName) }
        }
        
        // Apply sorting
        switch sortOption {
        case .alphabetical:
            filtered.sort { $0.name < $1.name }
        case .series:
            filtered.sort { getSeriesName(for: $0) < getSeriesName(for: $1) }
        case .color:
            filtered.sort { $0.color < $1.color }
        case .recent:
            // For now, sort by name as we don't have creation dates
            filtered.sort { $0.name > $1.name }
        case .owned:
            filtered.sort { (a, b) in
                let aOwned = collectionManager.isOwned(a.imageName)
                let bOwned = collectionManager.isOwned(b.imageName)
                if aOwned == bOwned {
                    return a.name < b.name
                }
                return aOwned && !bOwned
            }
        case .favorites:
            filtered.sort { (a, b) in
                let aFav = collectionManager.isFavorite(a.imageName)
                let bFav = collectionManager.isFavorite(b.imageName)
                if aFav == bFav {
                    return a.name < b.name
                }
                return aFav && !bFav
            }
        }
        
        return filtered
    }
    
    func filteredSeries() -> [ToySeries] {
        var filtered = toySeries
        
        if !searchText.isEmpty {
            filtered = filtered.filter { series in
                series.name.localizedCaseInsensitiveContains(searchText) ||
                series.chineseName.localizedCaseInsensitiveContains(searchText) ||
                series.description.localizedCaseInsensitiveContains(searchText) ||
                series.releases.contains { release in
                    release.name.localizedCaseInsensitiveContains(searchText) ||
                    release.chineseName.localizedCaseInsensitiveContains(searchText) ||
                    release.description.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        
        return filtered
    }
    
    private func getSeriesName(for release: ToyRelease) -> String {
        for series in toySeries {
            if series.releases.contains(where: { $0.imageName == release.imageName }) {
                return series.name
            }
        }
        return "Unknown Series"
    }
    
    func clearFilters() {
        searchText = ""
        selectedSeries.removeAll()
        sortOption = .alphabetical
        filterOption = .all
    }
    
    func hasActiveFilters() -> Bool {
        return !searchText.isEmpty || !selectedSeries.isEmpty || filterOption != .all || sortOption != .alphabetical
    }
}