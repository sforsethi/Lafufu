//
//  LabubuDetailView.swift
//  Lafufu
//
//  Created by Raghav Sethi on 21/06/25.
//
import SwiftUI

struct LabubuDetailView: View {
    let release: LabubuRelease
    @Environment(\.dismiss) private var dismiss
    @StateObject private var collectionManager = UserCollectionManager.shared
    @State private var showingImagePicker = false
    @State private var showingImageActionSheet = false
    @State private var selectedImage: UIImage?
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    private var isFavorite: Bool {
        collectionManager.isFavorite(release.id.uuidString)
    }
    
    private var isOwned: Bool {
        collectionManager.isOwned(release.id.uuidString)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Hero Image Section
                    VStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(hex: release.color).opacity(0.1))
                                .frame(height: 300)
                            
                            // Check if user has uploaded an image for this owned item
                            if isOwned, let ownedImage = collectionManager.getOwnedImage(release.id.uuidString) {
                                Image(uiImage: ownedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                    .overlay(
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Button {
                                                    showingImageActionSheet = true
                                                } label: {
                                                    Image(systemName: "camera.fill")
                                                        .font(.system(size: 16, weight: .semibold))
                                                        .foregroundColor(.white)
                                                        .padding(8)
                                                        .background(Color.black.opacity(0.6))
                                                        .clipShape(Circle())
                                                }
                                            }
                                            Spacer()
                                        }
                                        .padding(16)
                                    )
                            } else {
                                // Large version of the character
                                VStack(spacing: 8) {
                                    // Ears
                                    HStack(spacing: 32) {
                                        Ellipse()
                                            .fill(Color(hex: "F5E6D3"))
                                            .frame(width: 20, height: 32)
                                        Ellipse()
                                            .fill(Color(hex: "F5E6D3"))
                                            .frame(width: 20, height: 32)
                                    }
                                    .offset(y: -16)
                                    
                                    // Head with theme color
                                    Circle()
                                        .fill(Color(hex: release.color).opacity(0.3))
                                        .frame(width: 120, height: 120)
                                        .overlay(
                                            Circle()
                                                .stroke(Color(hex: release.color), lineWidth: 4)
                                        )
                                        .overlay(
                                            VStack(spacing: 4) {
                                                // Eyes
                                                HStack(spacing: 12) {
                                                    Circle()
                                                        .fill(Color.black)
                                                        .frame(width: 12, height: 12)
                                                    Circle()
                                                        .fill(Color.black)
                                                        .frame(width: 12, height: 12)
                                                }
                                                
                                                // Mouth
                                                Capsule()
                                                    .fill(Color.black)
                                                    .frame(width: 24, height: 4)
                                            }
                                        )
                                    
                                    // Large themed accessory
                                    largeAccessory(for: release.imageName)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // Character Info Section
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text(release.name)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Color(hex: release.color))
                                .multilineTextAlignment(.center)
                            
                            Text(release.chineseName)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        // Action Buttons
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                // Favorite Button
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        collectionManager.toggleFavorite(release.id.uuidString)
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(isFavorite ? .white : Color.red)
                                        
                                        Text(isFavorite ? "Favorited" : "Add to Favorites")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(isFavorite ? .white : Color.red)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(isFavorite ? Color.red : Color.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(Color.red, lineWidth: 2)
                                            )
                                    )
                                }
                                .scaleEffect(isFavorite ? 1.05 : 1.0)
                                
                                // Ownership Button
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        collectionManager.toggleOwned(release.id.uuidString)
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: isOwned ? "checkmark.circle.fill" : "plus.circle")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(isOwned ? .white : Color.green)
                                        
                                        Text(isOwned ? "Owned" : "I Own This")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(isOwned ? .white : Color.green)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(isOwned ? Color.green : Color.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(Color.green, lineWidth: 2)
                                            )
                                    )
                                }
                                .scaleEffect(isOwned ? 1.05 : 1.0)
                            }
                            
                            // Add Photo Button (only show if owned)
                            if isOwned {
                                Button {
                                    showingImageActionSheet = true
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: collectionManager.hasOwnedImage(release.id.uuidString) ? "photo.fill" : "camera.fill")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(Color.blue)
                                        
                                        Text(collectionManager.hasOwnedImage(release.id.uuidString) ? "Update Photo" : "Add Photo")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(Color.blue)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(Color.blue, lineWidth: 2)
                                            )
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Description Card
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Description")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            
                            Text(release.description)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .lineLimit(nil)
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        
                        // Character Stats Card
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Details")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            
                            VStack(spacing: 12) {
                                DetailRow(label: "Series", value: getSeriesName(for: release))
                                DetailRow(label: "Theme Color", value: release.color.uppercased())
                                DetailRow(label: "Type", value: "Collectible Figure")
                                DetailRow(label: "Rarity", value: "Limited Edition")
                                
                                // Status indicators
                                if isFavorite || isOwned {
                                    Divider()
                                        .padding(.vertical, 4)
                                    
                                    VStack(spacing: 8) {
                                        if isFavorite {
                                            HStack {
                                                Image(systemName: "heart.fill")
                                                    .foregroundColor(.red)
                                                Text("Added to Favorites")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.gray)
                                                Spacer()
                                            }
                                        }
                                        
                                        if isOwned {
                                            HStack {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.green)
                                                Text("In Your Collection")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.gray)
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.vertical, 24)
            }
            .background(Color(hex: "F3F4F6"))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: release.color))
                    .fontWeight(.semibold)
                }
            }
        }
        .actionSheet(isPresented: $showingImageActionSheet) {
            ActionSheet(
                title: Text("Add Photo"),
                message: Text("Choose how you'd like to add a photo of your Labubu"),
                buttons: [
                    .default(Text("Camera")) {
                        imageSourceType = .camera
                        showingImagePicker = true
                    },
                    .default(Text("Photo Library")) {
                        imageSourceType = .photoLibrary
                        showingImagePicker = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, isPresented: $showingImagePicker, sourceType: imageSourceType)
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage, let imageData = image.jpegData(compressionQuality: 0.7) {
                collectionManager.addOwnedImage(release.id.uuidString, imageData: imageData)
            }
        }
    }
    
    @ViewBuilder
    private func largeAccessory(for imageName: String) -> some View {
        // Create larger versions of the accessories based on the existing fruitAccessory function
        // This is a simplified version - you could expand this to show more detailed accessories
        switch imageName {
        case let name where name.contains("fruit") || name.contains("lemon") || name.contains("banana"):
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: release.color).opacity(0.6))
                .frame(width: 60, height: 40)
        case let name where name.contains("energy") || name.contains("love") || name.contains("happiness"):
            VStack(spacing: 4) {
                Circle()
                    .stroke(Color(hex: release.color), lineWidth: 4)
                    .frame(width: 24, height: 24)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: release.color).opacity(0.8))
                    .frame(width: 40, height: 24)
            }
        default:
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: release.color).opacity(0.6))
                .frame(width: 56, height: 36)
        }
    }
    
    private func getSeriesName(for release: LabubuRelease) -> String {
        for series in labubuSeries {
            if series.releases.contains(where: { $0.id == release.id }) {
                return series.name
            }
        }
        return "Unknown Series"
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.trailing)
        }
    }
}
