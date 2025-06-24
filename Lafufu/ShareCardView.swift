//
//  ShareCardView.swift
//  Lafufu
//
//  Created by Raghav Sethi on 24/06/25.
//

import SwiftUI
import UIKit

struct ShareCardView: View {
    private let collectionManager = UserCollectionManager.shared
    @State private var shareImage: UIImage?
    @State private var showingShareSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Card content that will be rendered as image
            cardContent
                .background(Color.clear)
        }
        .sheet(isPresented: $showingShareSheet) {
            if let shareImage = shareImage {
                ShareSheet(activityItems: [shareImage])
            }
        }
    }
    
    private var cardContent: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "667eea"),
                    Color(hex: "764ba2")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 60, height: 60)
                            
                            Text("🦔")
                                .font(.system(size: 32))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            if let userName = UserDefaults.standard.string(forKey: "userName") {
                                Text("\(userName)'s")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            Text("Lafufu Collection")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 32)
                }
                
                // Stats cards
                HStack(spacing: 16) {
                    StatCard(
                        title: "Owned",
                        value: "\(collectionManager.getOwnedCount())",
                        color: Color.green,
                        icon: "checkmark.circle.fill"
                    )
                    
                    StatCard(
                        title: "Favorites",
                        value: "\(collectionManager.getFavoritesCount())",
                        color: Color.red,
                        icon: "heart.fill"
                    )
                    
                    StatCard(
                        title: "Complete",
                        value: "\(String(format: "%.1f", collectionManager.getCompletionPercentage()))%",
                        color: Color.blue,
                        icon: "star.fill"
                    )
                }
                .padding(.horizontal, 24)
                
                // Featured items preview
                if !getOwnedReleases().isEmpty {
                    VStack(spacing: 12) {
                        Text("Recent Finds")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            ForEach(Array(getOwnedReleases().prefix(3).enumerated()), id: \.offset) { _, release in
                                FeaturedItemCard(release: release)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 32)
                    }
                }
                
                Spacer(minLength: 16)
                
                // Footer
                VStack(spacing: 4) {
                    Text("Share your collection!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("#Lafufu #CollectibleToys")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.bottom, 24)
            }
        }
        .frame(width: 400, height: 600)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    private func getOwnedReleases() -> [ToyRelease] {
        let allReleases = toySeries.flatMap { $0.releases }
        return allReleases.filter { release in
            collectionManager.isOwned(release.imageName)
        }
    }
    
    func generateShareImage() {
        print("DEBUG: Starting share image generation...")
        let renderer = ImageRenderer(content: StaticShareCardContent())
        renderer.scale = 3.0 // High resolution for social media
        
        print("DEBUG: Renderer created, generating image...")
        if let uiImage = renderer.uiImage {
            print("DEBUG: Image generated successfully! Size: \(uiImage.size)")
            shareImage = uiImage
            showingShareSheet = true
        } else {
            print("DEBUG: Failed to generate image")
        }
    }
}

struct StaticShareCardContent: View {
    private let collectionManager = UserCollectionManager.shared
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "667eea"),
                    Color(hex: "764ba2")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 60, height: 60)
                            
                            Text("🦔")
                                .font(.system(size: 32))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            if let userName = UserDefaults.standard.string(forKey: "userName") {
                                Text("\(userName)'s")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            Text("Lafufu Collection")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 32)
                }
                
                // Stats cards
                HStack(spacing: 16) {
                    StatCard(
                        title: "Owned",
                        value: "\(collectionManager.getOwnedCount())",
                        color: Color.green,
                        icon: "checkmark.circle.fill"
                    )
                    
                    StatCard(
                        title: "Favorites",
                        value: "\(collectionManager.getFavoritesCount())",
                        color: Color.red,
                        icon: "heart.fill"
                    )
                    
                    StatCard(
                        title: "Complete",
                        value: "\(String(format: "%.1f", collectionManager.getCompletionPercentage()))%",
                        color: Color.blue,
                        icon: "star.fill"
                    )
                }
                .padding(.horizontal, 24)
                
                // Featured items preview
                let ownedReleases = getOwnedReleases()
                if !ownedReleases.isEmpty {
                    VStack(spacing: 12) {
                        Text("Recent Finds")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            ForEach(Array(ownedReleases.prefix(3).enumerated()), id: \.offset) { _, release in
                                FeaturedItemCard(release: release)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 32)
                    }
                }
                
                Spacer(minLength: 16)
                
                // Footer
                VStack(spacing: 4) {
                    Text("Share your collection!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("#Lafufu #CollectibleToys")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.bottom, 24)
            }
        }
        .frame(width: 400, height: 600)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    private func getOwnedReleases() -> [ToyRelease] {
        let allReleases = toySeries.flatMap { $0.releases }
        let ownedReleases = allReleases.filter { release in
            collectionManager.isOwned(release.imageName)
        }
        print("DEBUG: StaticShareCardContent - Total releases: \(allReleases.count), Owned: \(ownedReleases.count)")
        print("DEBUG: Owned count from manager: \(collectionManager.getOwnedCount())")
        print("DEBUG: Favorites count from manager: \(collectionManager.getFavoritesCount())")
        print("DEBUG: Completion percentage: \(collectionManager.getCompletionPercentage())")
        
        // Log which owned items have photos
        for release in ownedReleases.prefix(3) {
            let hasImage = collectionManager.hasOwnedImage(release.imageName)
            print("DEBUG: Featured item '\(release.name)' has user photo: \(hasImage)")
        }
        
        return ownedReleases
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                
                VStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                    
                    Text(value)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
}

struct FeaturedItemCard: View {
    let release: ToyRelease
    private let collectionManager = UserCollectionManager.shared
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 60, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                
                // Show real user image if available, otherwise show placeholder
                if let userImage = collectionManager.getOwnedImage(release.imageName) {
                    Image(uiImage: userImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 56, height: 56)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    // Fallback to mini character representation
                    Circle()
                        .fill(Color(hex: release.color))
                        .frame(width: 28, height: 28)
                        .overlay(
                            VStack(spacing: 1) {
                                HStack(spacing: 2) {
                                    Circle().fill(Color.black).frame(width: 2, height: 2)
                                    Circle().fill(Color.black).frame(width: 2, height: 2)
                                }
                                Capsule().fill(Color.black).frame(width: 6, height: 1)
                            }
                        )
                }
            }
            
            Text(release.name)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }
}

 

struct ShareCardGeneratorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingShareSheet = false
    @State private var generatedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Share Your Collection")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Generate a beautiful card to share your Lafufu collection progress on social media!")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                // Preview of the card
                ShareCardView()
                    .scaleEffect(0.7)
                    .allowsHitTesting(false)
                
                Spacer()
                
                // Generate and share button
                Button(action: {
                    print("DEBUG: Share button tapped")
                    generateAndShare()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "camera")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Generate & Share")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(Color(hex: "F0F0F0"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "667eea"))
                    .fontWeight(.semibold)
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let generatedImage = generatedImage {
                ShareSheet(activityItems: [generatedImage])
            }
        }
    }
    
    private func generateAndShare() {
        print("DEBUG: Starting image generation...")
        let renderer = ImageRenderer(content: StaticShareCardContent())
        renderer.scale = 3.0 // High resolution for social media
        
        print("DEBUG: Renderer created, generating image...")
        if let uiImage = renderer.uiImage {
            print("DEBUG: Image generated successfully! Size: \(uiImage.size)")
            generatedImage = uiImage
            showingShareSheet = true
        } else {
            print("DEBUG: Failed to generate image")
        }
    }
}

struct ShareCardView_Previews: PreviewProvider {
    static var previews: some View {
        ShareCardGeneratorView()
    }
}
