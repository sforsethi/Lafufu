//
//  PhotoManager.swift
//  Lafufu
//
//  Enhanced photo management with multiple photos support
//

import SwiftUI
import UIKit
import Photos

struct ToyPhoto: Identifiable, Codable {
    let id = UUID()
    let imageName: String // toy identifier
    let fileName: String
    let dateAdded: Date
    let caption: String?
    let isMainPhoto: Bool
    
    init(imageName: String, fileName: String, caption: String? = nil, isMainPhoto: Bool = false) {
        self.imageName = imageName
        self.fileName = fileName
        self.dateAdded = Date()
        self.caption = caption
        self.isMainPhoto = isMainPhoto
    }
}

class PhotoManager: ObservableObject {
    @Published var photos: [ToyPhoto] = []
    
    private let documentsDirectory: URL
    private let photosDirectory: URL
    
    init() {
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        photosDirectory = documentsDirectory.appendingPathComponent("ToyPhotos")
        
        // Create photos directory if it doesn't exist
        try? FileManager.default.createDirectory(at: photosDirectory, withIntermediateDirectories: true)
        
        loadPhotos()
    }
    
    func addPhoto(for toyImageName: String, image: UIImage, caption: String? = nil, setAsMain: Bool = false) {
        let fileName = "\(toyImageName)_\(UUID().uiString).jpg"
        let fileURL = photosDirectory.appendingPathComponent(fileName)
        
        // Save image to file system
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            do {
                try imageData.write(to: fileURL)
                
                // If this is the first photo or explicitly set as main, make it the main photo
                let isMain = setAsMain || !hasPhotos(for: toyImageName)
                
                // If setting as main, update existing photos
                if isMain {
                    photos = photos.map { photo in
                        if photo.imageName == toyImageName {
                            return ToyPhoto(imageName: photo.imageName, fileName: photo.fileName, caption: photo.caption, isMainPhoto: false)
                        }
                        return photo
                    }
                }
                
                let newPhoto = ToyPhoto(imageName: toyImageName, fileName: fileName, caption: caption, isMainPhoto: isMain)
                photos.append(newPhoto)
                savePhotos()
                
                HapticManager.notification(.success)
            } catch {
                print("Error saving photo: \(error)")
                HapticManager.notification(.error)
            }
        }
    }
    
    func getPhotos(for toyImageName: String) -> [ToyPhoto] {
        return photos.filter { $0.imageName == toyImageName }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    func getMainPhoto(for toyImageName: String) -> ToyPhoto? {
        return photos.first { $0.imageName == toyImageName && $0.isMainPhoto }
    }
    
    func loadImage(for photo: ToyPhoto) -> UIImage? {
        let fileURL = photosDirectory.appendingPathComponent(photo.fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func hasPhotos(for toyImageName: String) -> Bool {
        return photos.contains { $0.imageName == toyImageName }
    }
    
    func setMainPhoto(_ photo: ToyPhoto) {
        photos = photos.map { existingPhoto in
            if existingPhoto.imageName == photo.imageName {
                return ToyPhoto(
                    imageName: existingPhoto.imageName,
                    fileName: existingPhoto.fileName,
                    caption: existingPhoto.caption,
                    isMainPhoto: existingPhoto.id == photo.id
                )
            }
            return existingPhoto
        }
        savePhotos()
        HapticManager.impact(.light)
    }
    
    func updateCaption(for photo: ToyPhoto, caption: String) {
        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
            photos[index] = ToyPhoto(
                imageName: photo.imageName,
                fileName: photo.fileName,
                caption: caption.isEmpty ? nil : caption,
                isMainPhoto: photo.isMainPhoto
            )
            savePhotos()
        }
    }
    
    func deletePhoto(_ photo: ToyPhoto) {
        let fileURL = photosDirectory.appendingPathComponent(photo.fileName)
        try? FileManager.default.removeItem(at: fileURL)
        
        photos.removeAll { $0.id == photo.id }
        
        // If deleted photo was main, set another photo as main
        if photo.isMainPhoto, let newMainPhoto = photos.first(where: { $0.imageName == photo.imageName }) {
            setMainPhoto(newMainPhoto)
        }
        
        savePhotos()
        HapticManager.notification(.warning)
    }
    
    private func savePhotos() {
        let photosURL = documentsDirectory.appendingPathComponent("photos.json")
        if let data = try? JSONEncoder().encode(photos) {
            try? data.write(to: photosURL)
        }
    }
    
    private func loadPhotos() {
        let photosURL = documentsDirectory.appendingPathComponent("photos.json")
        if let data = try? Data(contentsOf: photosURL),
           let loadedPhotos = try? JSONDecoder().decode([ToyPhoto].self, from: data) {
            photos = loadedPhotos
        }
    }
}

struct PhotoGalleryView: View {
    let toyImageName: String
    @StateObject private var photoManager = PhotoManager()
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedImage: UIImage?
    @State private var editingPhoto: ToyPhoto?
    @State private var newCaption = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        mainContent
            .background(AppColors.background(for: colorScheme))
            .navigationTitle("Photos")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage, isPresented: $showingImagePicker, sourceType: .photoLibrary)
            }
            .actionSheet(isPresented: $showingCamera) {
                photoActionSheet
            }
            .alert("Edit Caption", isPresented: .constant(editingPhoto != nil)) {
                captionEditAlert
            }
            .onChange(of: selectedImage) { image in
                handleImageSelection(image)
            }
    }
    
    private var mainContent: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 12) {
                addPhotoButton
                
                ForEach(photoManager.getPhotos(for: toyImageName)) { photo in
                    PhotoGridItem(photo: photo, photoManager: photoManager) {
                        editingPhoto = photo
                        newCaption = photo.caption ?? ""
                    }
                }
            }
            .padding()
        }
    }
    
    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ]
    }
    
    private var addPhotoButton: some View {
        Button(action: { showingImagePicker = true }) {
            addPhotoButtonContent
        }
    }
    
    private var addPhotoButtonContent: some View {
        VStack(spacing: 8) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(AppColors.accent(for: colorScheme))
            
            Text("Add Photo")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.secondaryText(for: colorScheme))
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground(for: colorScheme))
        .cornerRadius(12)
        .overlay(dashedBorder)
    }
    
    private var dashedBorder: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(
                AppColors.accent(for: colorScheme).opacity(0.3),
                style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [5])
            )
    }
    
    private var photoActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Add Photo"),
            buttons: [
                .default(Text("Camera")) {
                    showingImagePicker = true
                },
                .default(Text("Photo Library")) {
                    showingImagePicker = true
                },
                .cancel()
            ]
        )
    }
    
    @ViewBuilder
    private var captionEditAlert: some View {
        TextField("Caption", text: $newCaption)
        Button("Save") {
            if let photo = editingPhoto {
                photoManager.updateCaption(for: photo, caption: newCaption)
            }
            editingPhoto = nil
        }
        Button("Cancel", role: .cancel) {
            editingPhoto = nil
        }
    }
    
    private func handleImageSelection(_ image: UIImage?) {
        if let image = image {
            photoManager.addPhoto(for: toyImageName, image: image)
            selectedImage = nil
        }
    }
}

struct PhotoGridItem: View {
    let photo: ToyPhoto
    let photoManager: PhotoManager
    let onEdit: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            if let image = photoManager.loadImage(for: photo) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(12)
                    .overlay(
                        VStack {
                            HStack {
                                if photo.isMainPhoto {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.yellow)
                                        .padding(4)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                Spacer()
                                Menu {
                                    Button("Set as Main") {
                                        photoManager.setMainPhoto(photo)
                                    }
                                    Button("Edit Caption") {
                                        onEdit()
                                    }
                                    Button("Delete", role: .destructive) {
                                        photoManager.deletePhoto(photo)
                                    }
                                } label: {
                                    Image(systemName: "ellipsis.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                            }
                            Spacer()
                            if let caption = photo.caption {
                                Text(caption)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(4)
                            }
                        }
                        .padding(8)
                    )
            }
        }
    }
}

extension UUID {
    var uiString: String {
        return uuidString.replacingOccurrences(of: "-", with: "")
    }
}