//
//  EnhancedShareSystem.swift
//  Lafufu
//
//  Advanced sharing system with multiple templates
//

import SwiftUI
import UIKit

enum ShareTemplate: String, CaseIterable {
    case modern = "Modern"
    case minimal = "Minimal"
    case showcase = "Showcase"
    case achievement = "Achievement"
    case series = "Series Focus"
    case progress = "Progress"
    
    var displayName: String { rawValue }
    
    var systemImage: String {
        switch self {
        case .modern: return "rectangle.fill.on.rectangle.angled.fill"
        case .minimal: return "square.fill"
        case .showcase: return "photo.fill.on.rectangle.fill"
        case .achievement: return "trophy.fill"
        case .series: return "folder.fill"
        case .progress: return "chart.pie.fill"
        }
    }
    
    var description: String {
        switch self {
        case .modern: return "Clean gradient design with stats"
        case .minimal: return "Simple, text-focused layout"
        case .showcase: return "Highlight your best photos"
        case .achievement: return "Celebrate milestones"
        case .series: return "Focus on specific series"
        case .progress: return "Show collection progress"
        }
    }
}

struct EnhancedShareCardGenerator: View {
    @State private var selectedTemplate: ShareTemplate = .modern
    @State private var selectedSeries: ToySeries?
    @State private var includePhotos = true
    @State private var includeStats = true
    @State private var customMessage = ""
    @State private var backgroundColor = Color(hex: "667eea")
    @State private var generatedImage: UIImage?
    @State private var showingShareSheet = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    private let collectionManager = UserCollectionManager.shared
    private let photoManager = PhotoManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Template Selection
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Choose Template")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(ShareTemplate.allCases, id: \.self) { template in
                                    TemplateCard(
                                        template: template,
                                        isSelected: selectedTemplate == template
                                    ) {
                                        selectedTemplate = template
                                        HapticManager.selection()
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Customization Options
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Customize")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                        
                        VStack(spacing: 12) {
                            // Series Selection (for series template)
                            if selectedTemplate == .series {
                                Menu {
                                    ForEach(toySeries, id: \.id) { series in
                                        Button(series.name) {
                                            selectedSeries = series
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedSeries?.name ?? "Select Series")
                                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(AppColors.secondaryText(for: colorScheme))
                                    }
                                    .padding()
                                    .background(AppColors.cardBackground(for: colorScheme))
                                    .cornerRadius(12)
                                }
                            }
                            
                            // Toggle Options
                            CustomToggle(title: "Include Photos", isOn: $includePhotos)
                            CustomToggle(title: "Include Stats", isOn: $includeStats)
                            
                            // Custom Message
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Custom Message")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText(for: colorScheme))
                                
                                TextField("Add a personal message...", text: $customMessage)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            // Color Picker
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Background Color")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.primaryText(for: colorScheme))
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach([
                                            Color(hex: "667eea"),
                                            Color(hex: "764ba2"),
                                            Color(hex: "f093fb"),
                                            Color(hex: "f5576c"),
                                            Color(hex: "4facfe"),
                                            Color(hex: "00f2fe")
                                        ], id: \.self) { color in
                                            Circle()
                                                .fill(color)
                                                .frame(width: 40, height: 40)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.white, lineWidth: backgroundColor == color ? 3 : 0)
                                                )
                                                .onTapGesture {
                                                    backgroundColor = color
                                                    HapticManager.impact(.light)
                                                }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding()
                        .background(AppColors.cardBackground(for: colorScheme))
                        .cornerRadius(16)
                    }
                    
                    // Preview
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Preview")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                        
                        ShareCardPreview(
                            template: selectedTemplate,
                            selectedSeries: selectedSeries,
                            includePhotos: includePhotos,
                            includeStats: includeStats,
                            customMessage: customMessage,
                            backgroundColor: backgroundColor
                        )
                        .scaleEffect(0.6)
                        .frame(height: 300)
                        .clipped()
                    }
                    
                    // Generate Button
                    Button(action: generateAndShare) {
                        HStack(spacing: 12) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Generate & Share")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColors.gradient(for: colorScheme))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .background(AppColors.background(for: colorScheme))
            .navigationTitle("Share Collection")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent(for: colorScheme))
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
        HapticManager.impact()
        
        let shareCard = ShareCardPreview(
            template: selectedTemplate,
            selectedSeries: selectedSeries,
            includePhotos: includePhotos,
            includeStats: includeStats,
            customMessage: customMessage,
            backgroundColor: backgroundColor
        )
        
        let renderer = ImageRenderer(content: shareCard)
        renderer.scale = 3.0
        
        if let uiImage = renderer.uiImage {
            generatedImage = uiImage
            showingShareSheet = true
            HapticManager.notification(.success)
        } else {
            HapticManager.notification(.error)
        }
    }
}

struct TemplateCard: View {
    let template: ShareTemplate
    let isSelected: Bool
    let onTap: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: template.systemImage)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? .white : AppColors.accent(for: colorScheme))
                .frame(width: 60, height: 60)
                .background(
                    isSelected ? AppColors.accent(for: colorScheme) : AppColors.cardBackground(for: colorScheme)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected ? AppColors.accent(for: colorScheme) : Color.clear,
                            lineWidth: 2
                        )
                )
            
            VStack(spacing: 2) {
                Text(template.displayName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(AppColors.primaryText(for: colorScheme))
                
                Text(template.description)
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.secondaryText(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(width: 100)
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct CustomToggle: View {
    let title: String
    @Binding var isOn: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.primaryText(for: colorScheme))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .onChange(of: isOn) { _ in
                    HapticManager.selection()
                }
        }
    }
}

struct ShareCardPreview: View {
    let template: ShareTemplate
    let selectedSeries: ToySeries?
    let includePhotos: Bool
    let includeStats: Bool
    let customMessage: String
    let backgroundColor: Color
    
    private let collectionManager = UserCollectionManager.shared
    private let photoManager = PhotoManager()
    
    var body: some View {
        ZStack {
            backgroundColor
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            backgroundColor,
                            backgroundColor.opacity(0.7)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 20) {
                // Header
                headerView
                
                // Content based on template
                switch template {
                case .modern:
                    modernContent
                case .minimal:
                    minimalContent
                case .showcase:
                    showcaseContent
                case .achievement:
                    achievementContent
                case .series:
                    seriesContent
                case .progress:
                    progressContent
                }
                
                Spacer()
                
                // Footer with custom message
                if !customMessage.isEmpty {
                    Text(customMessage)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Text("#Lafufu #CollectibleToys")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(24)
        }
        .frame(width: 400, height: 600)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    private var headerView: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text("🦔")
                    .font(.system(size: 24))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                if let userName = UserDefaults.standard.string(forKey: "userName") {
                    Text("\(userName)'s")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                Text("Lafufu Collection")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
    
    @ViewBuilder
    private var modernContent: some View {
        if includeStats {
            HStack(spacing: 12) {
                StatCard(title: "Owned", value: "\(collectionManager.getOwnedCount())", color: .green, icon: "checkmark.circle.fill")
                StatCard(title: "Favorites", value: "\(collectionManager.getFavoritesCount())", color: .red, icon: "heart.fill")
                StatCard(title: "Complete", value: "\(String(format: "%.1f", collectionManager.getCompletionPercentage()))%", color: .blue, icon: "star.fill")
            }
        }
        
        if includePhotos {
            featuredPhotosView
        }
    }
    
    @ViewBuilder
    private var minimalContent: some View {
        VStack(spacing: 16) {
            Text("Collection Status")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            if includeStats {
                VStack(spacing: 8) {
                    Text("\(collectionManager.getOwnedCount()) Toys Collected")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("\(String(format: "%.1f", collectionManager.getCompletionPercentage()))% Complete")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
    }
    
    @ViewBuilder
    private var showcaseContent: some View {
        if includePhotos {
            featuredPhotosView
        }
    }
    
    @ViewBuilder
    private var achievementContent: some View {
        VStack(spacing: 16) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 40))
                .foregroundColor(.yellow)
            
            Text("Achievement Unlocked!")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            if includeStats {
                Text("\(collectionManager.getOwnedCount()) toys collected")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
            }
        }
    }
    
    @ViewBuilder
    private var seriesContent: some View {
        if let series = selectedSeries {
            VStack(spacing: 12) {
                Text("Series Focus")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                
                Text(series.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                if includeStats {
                    let ownedInSeries = series.releases.filter { collectionManager.isOwned($0.imageName) }.count
                    Text("\(ownedInSeries)/\(series.releases.count) collected")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
    
    @ViewBuilder
    private var progressContent: some View {
        VStack(spacing: 16) {
            Text("Collection Progress")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            if includeStats {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 8)
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0, to: collectionManager.getCompletionPercentage() / 100)
                        .stroke(Color.white, lineWidth: 8)
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(String(format: "%.0f", collectionManager.getCompletionPercentage()))%")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    @ViewBuilder
    private var featuredPhotosView: some View {
        let ownedReleases = getOwnedReleases()
        if !ownedReleases.isEmpty {
            VStack(spacing: 8) {
                Text("Recent Finds")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    ForEach(Array(ownedReleases.prefix(3).enumerated()), id: \.offset) { _, release in
                        if let mainPhoto = photoManager.getMainPhoto(for: release.imageName),
                           let image = photoManager.loadImage(for: mainPhoto) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: release.color))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text(String(release.name.prefix(1)))
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func getOwnedReleases() -> [ToyRelease] {
        let allReleases = toySeries.flatMap { $0.releases }
        return allReleases.filter { release in
            collectionManager.isOwned(release.imageName)
        }
    }
}