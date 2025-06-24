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
    
    @Published private var ownedItems: Set<String> = []
    @Published private var favoriteItems: Set<String> = []
    @Published private var ownedImages: [String: Data] = [:]
    
    private let ownedItemsKey = "ownedItems"
    private let favoriteItemsKey = "favoriteItems"
    private let ownedImagesKey = "ownedImages"
    
    private init() {
        loadData()
    }
    
    // MARK: - Data Persistence
    
    private func loadData() {
        // Load owned items
        if let ownedData = UserDefaults.standard.array(forKey: ownedItemsKey) as? [String] {
            ownedItems = Set(ownedData)
        }
        
        // Load favorite items
        if let favoriteData = UserDefaults.standard.array(forKey: favoriteItemsKey) as? [String] {
            favoriteItems = Set(favoriteData)
        }
        
        // Load owned images
        if let imagesData = UserDefaults.standard.data(forKey: ownedImagesKey),
           let decodedImages = try? JSONDecoder().decode([String: Data].self, from: imagesData) {
            ownedImages = decodedImages
        }
    }
    
    // Force refresh data method
    func refreshData() {
        DispatchQueue.main.async {
            self.loadData()
            print("DEBUG: After refresh - Owned items: \(Array(self.ownedItems))")
            print("DEBUG: After refresh - Favorite items: \(Array(self.favoriteItems))")
            self.objectWillChange.send()
        }
    }
    
    private func saveData() {
        // Save owned items
        UserDefaults.standard.set(Array(ownedItems), forKey: ownedItemsKey)
        
        // Save favorite items
        UserDefaults.standard.set(Array(favoriteItems), forKey: favoriteItemsKey)
        
        // Save owned images
        if let encodedImages = try? JSONEncoder().encode(ownedImages) {
            UserDefaults.standard.set(encodedImages, forKey: ownedImagesKey)
        }
        
        // Force UI update after saving
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // MARK: - Ownership Management
    
    func toggleOwned(_ imageName: String) {
        print("DEBUG: Toggling owned for: \(imageName)")
        if ownedItems.contains(imageName) {
            ownedItems.remove(imageName)
            // Also remove image if it exists
            ownedImages.removeValue(forKey: imageName)
            print("DEBUG: Removed \(imageName) from owned")
        } else {
            ownedItems.insert(imageName)
            print("DEBUG: Added \(imageName) to owned")
        }
        print("DEBUG: Current owned items: \(Array(ownedItems))")
        saveData()
    }
    
    func isOwned(_ imageName: String) -> Bool {
        return ownedItems.contains(imageName)
    }
    
    func getOwnedCount() -> Int {
        return ownedItems.count
    }
    
    // MARK: - Favorites Management
    
    func toggleFavorite(_ imageName: String) {
        print("DEBUG: Toggling favorite for: \(imageName)")
        if favoriteItems.contains(imageName) {
            favoriteItems.remove(imageName)
            print("DEBUG: Removed \(imageName) from favorites")
        } else {
            favoriteItems.insert(imageName)
            print("DEBUG: Added \(imageName) to favorites")
        }
        print("DEBUG: Current favorite items: \(Array(favoriteItems))")
        saveData()
    }
    
    func isFavorite(_ imageName: String) -> Bool {
        return favoriteItems.contains(imageName)
    }
    
    func getFavoritesCount() -> Int {
        return favoriteItems.count
    }
    
    // MARK: - Images Management
    
    func addOwnedImage(_ imageName: String, imageData: Data) {
        ownedImages[imageName] = imageData
        saveData()
    }
    
    func getOwnedImage(_ imageName: String) -> UIImage? {
        guard let imageData = ownedImages[imageName] else { return nil }
        return UIImage(data: imageData)
    }
    
    func hasOwnedImage(_ imageName: String) -> Bool {
        return ownedImages[imageName] != nil
    }
    
    func removeOwnedImage(_ imageName: String) {
        ownedImages.removeValue(forKey: imageName)
        saveData()
    }
    
    // MARK: - Statistics
    
    func getCompletionPercentage() -> Double {
        let totalItems = getAllReleases().count
        guard totalItems > 0 else { return 0.0 }
        return (Double(ownedItems.count) / Double(totalItems)) * 100.0
    }
    
    private func getAllReleases() -> [ToyRelease] {
        return toySeries.flatMap { $0.releases }
    }
    
    // MARK: - Debug Methods
    
    func getStoredOwnedItems() -> [String] {
        return Array(ownedItems)
    }
    
    func getStoredFavoriteItems() -> [String] {
        return Array(favoriteItems)
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
