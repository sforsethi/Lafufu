//
//  UserCollectionManager.swift
//  Lafufu
//
//  Created by Raghav Sethi on 21/06/25.
//

import SwiftUI
import UIKit

class UserCollectionManager: ObservableObject {
    static let shared = UserCollectionManager()
    
    private let favoritesKey = "user_favorites"
    private let ownedItemsKey = "user_owned_items"
    private let ownedImagesKey = "user_owned_images"
    
    @Published var favorites: Set<String> = []
    @Published var ownedItems: Set<String> = []
    @Published var ownedImages: [String: Data] = [:]
    
    private init() {
        loadFavorites()
        loadOwnedItems()
        loadOwnedImages()
    }
    
    // MARK: - Favorites Management
    func addToFavorites(_ releaseId: String) {
        favorites.insert(releaseId)
        saveFavorites()
    }
    
    func removeFromFavorites(_ releaseId: String) {
        favorites.remove(releaseId)
        saveFavorites()
    }
    
    func isFavorite(_ releaseId: String) -> Bool {
        return favorites.contains(releaseId)
    }
    
    func toggleFavorite(_ releaseId: String) {
        if isFavorite(releaseId) {
            removeFromFavorites(releaseId)
        } else {
            addToFavorites(releaseId)
        }
    }
    
    // MARK: - Owned Items Management
    func addToOwned(_ releaseId: String) {
        ownedItems.insert(releaseId)
        saveOwnedItems()
    }
    
    func removeFromOwned(_ releaseId: String) {
        ownedItems.remove(releaseId)
        saveOwnedItems()
        // Also remove associated image
        removeOwnedImage(releaseId)
    }
    
    func isOwned(_ releaseId: String) -> Bool {
        return ownedItems.contains(releaseId)
    }
    
    func toggleOwned(_ releaseId: String) {
        if isOwned(releaseId) {
            removeFromOwned(releaseId)
        } else {
            addToOwned(releaseId)
        }
    }
    
    // MARK: - Owned Images Management
    func addOwnedImage(_ releaseId: String, imageData: Data) {
        ownedImages[releaseId] = imageData
        saveOwnedImages()
    }
    
    func removeOwnedImage(_ releaseId: String) {
        ownedImages.removeValue(forKey: releaseId)
        saveOwnedImages()
    }
    
    func getOwnedImage(_ releaseId: String) -> UIImage? {
        guard let imageData = ownedImages[releaseId] else { return nil }
        return UIImage(data: imageData)
    }
    
    func hasOwnedImage(_ releaseId: String) -> Bool {
        return ownedImages[releaseId] != nil
    }
    
    // MARK: - UserDefaults Persistence
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        let savedFavorites = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
        favorites = Set(savedFavorites)
    }
    
    private func saveOwnedItems() {
        UserDefaults.standard.set(Array(ownedItems), forKey: ownedItemsKey)
    }
    
    private func loadOwnedItems() {
        let savedOwnedItems = UserDefaults.standard.stringArray(forKey: ownedItemsKey) ?? []
        ownedItems = Set(savedOwnedItems)
    }
    
    private func saveOwnedImages() {
        UserDefaults.standard.set(ownedImages, forKey: ownedImagesKey)
    }
    
    private func loadOwnedImages() {
        ownedImages = UserDefaults.standard.dictionary(forKey: ownedImagesKey) as? [String: Data] ?? [:]
    }
    
    // MARK: - Statistics
    func getFavoritesCount() -> Int {
        return favorites.count
    }
    
    func getOwnedCount() -> Int {
        return ownedItems.count
    }
    
    func getCompletionPercentage() -> Double {
        let totalItems = getAllReleasesCount()
        guard totalItems > 0 else { return 0.0 }
        return Double(ownedItems.count) / Double(totalItems) * 100.0
    }
    
    private func getAllReleasesCount() -> Int {
        return labubuSeries.reduce(0) { total, series in
            total + series.releases.count
        }
    }
}

// MARK: - Image Picker Coordinator
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}