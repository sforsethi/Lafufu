//
//  DeepLinkManager.swift
//  Lafufu
//
//  Comprehensive deep linking system for App Store Connect events and navigation
//

import SwiftUI
import Foundation

enum DeepLinkDestination {
    case home
    case explore
    case collection
    case wishlist
    case toyDetail(String) // toy imageName
    case series(String) // series name
    case event(String) // event ID
    case shareCard
    case photoGallery(String) // toy imageName
}

class DeepLinkManager: ObservableObject {
    @Published var activeDestination: DeepLinkDestination?
    @Published var showingDeepLinkedContent = false
    
    static let shared = DeepLinkManager()
    
    private init() {
        // Listen for deep link notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDeepLinkNotification),
            name: .navigateToEvent,
            object: nil
        )
    }
    
    // MARK: - URL Parsing
    
    func handleURL(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("❌ Failed to parse URL components: \(url)")
            return
        }
        
        print("🔗 Processing deep link: \(url)")
        print("📍 Scheme: \(components.scheme ?? "none")")
        print("📍 Host: \(components.host ?? "none")")
        print("📍 Path: \(components.path)")
        print("🔍 Query items: \(components.queryItems ?? [])")
        
        // Handle different URL schemes
        switch components.scheme {
        case "lafufu":
            handleCustomScheme(components)
        case "https":
            handleUniversalLink(components)
        default:
            print("❌ Unsupported URL scheme: \(components.scheme ?? "none")")
        }
    }
    
    private func handleCustomScheme(_ components: URLComponents) {
        let pathComponents = components.path.components(separatedBy: "/").filter { !$0.isEmpty }
        
        switch pathComponents.first {
        case "explore":
            navigate(to: .explore)
        case "collection":
            navigate(to: .collection)
        case "wishlist":
            navigate(to: .wishlist)
        case "toy":
            if pathComponents.count > 1 {
                navigate(to: .toyDetail(pathComponents[1]))
            }
        case "series":
            if pathComponents.count > 1 {
                let seriesName = pathComponents[1].replacingOccurrences(of: "-", with: " ")
                navigate(to: .series(seriesName))
            }
        case "event":
            if pathComponents.count > 1 {
                navigate(to: .event(pathComponents[1]))
            } else if let eventId = components.queryItems?.first(where: { $0.name == "id" })?.value {
                navigate(to: .event(eventId))
            }
        case "share":
            navigate(to: .shareCard)
        case "photos":
            if pathComponents.count > 1 {
                navigate(to: .photoGallery(pathComponents[1]))
            }
        default:
            navigate(to: .home)
        }
    }
    
    private func handleUniversalLink(_ components: URLComponents) {
        // Handle GitHub Pages universal links for events
        let pathComponents = components.path.components(separatedBy: "/").filter { !$0.isEmpty }
        
        if pathComponents.count >= 2 && pathComponents[0] == "events" {
            let eventId = pathComponents[1]
            print("✅ Event ID found from universal link: \(eventId)")
            navigate(to: .event(eventId))
        } else if components.path == "/event" {
            if let eventId = components.queryItems?.first(where: { $0.name == "id" })?.value {
                print("✅ Event ID found from query: \(eventId)")
                navigate(to: .event(eventId))
            }
        } else {
            print("❌ Unrecognized universal link path: \(components.path)")
        }
    }
    
    @objc private func handleDeepLinkNotification(_ notification: Notification) {
        if let eventId = notification.object as? String {
            navigate(to: .event(eventId))
        }
    }
    
    // MARK: - Navigation
    
    func navigate(to destination: DeepLinkDestination) {
        DispatchQueue.main.async {
            self.activeDestination = destination
            self.showingDeepLinkedContent = true
            HapticManager.notification(.success)
        }
    }
    
    func clearActiveDestination() {
        activeDestination = nil
        showingDeepLinkedContent = false
    }
    
    // MARK: - URL Generation for Sharing
    
    func generateShareURL(for destination: DeepLinkDestination) -> URL? {
        switch destination {
        case .home:
            return URL(string: "lafufu://home")
        case .explore:
            return URL(string: "lafufu://explore")
        case .collection:
            return URL(string: "lafufu://collection")
        case .wishlist:
            return URL(string: "lafufu://wishlist")
        case .toyDetail(let imageName):
            return URL(string: "lafufu://toy/\(imageName)")
        case .series(let seriesName):
            let encodedName = seriesName.replacingOccurrences(of: " ", with: "-")
            return URL(string: "lafufu://series/\(encodedName)")
        case .event(let eventId):
            return URL(string: "lafufu://event/\(eventId)")
        case .shareCard:
            return URL(string: "lafufu://share")
        case .photoGallery(let imageName):
            return URL(string: "lafufu://photos/\(imageName)")
        }
    }
    
    // MARK: - App Store Connect Event URLs
    
    func generateAppStoreEventURL(eventId: String) -> URL? {
        // This should match your GitHub Pages domain for universal links
        return URL(string: "https://sforsethi.github.io/Lafufu/events/\(eventId)")
    }
}

// MARK: - Deep Link View Modifier

struct DeepLinkHandler: ViewModifier {
    @StateObject private var deepLinkManager = DeepLinkManager.shared
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $deepLinkManager.showingDeepLinkedContent) {
                if let destination = deepLinkManager.activeDestination {
                    DeepLinkContentView(destination: destination)
                }
            }
            .onOpenURL { url in
                deepLinkManager.handleURL(url)
            }
    }
}

struct DeepLinkContentView: View {
    let destination: DeepLinkDestination
    @StateObject private var deepLinkManager = DeepLinkManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Group {
            switch destination {
            case .home:
                ContentView()
            case .explore:
                NavigationView {
                    ExploreView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") { dismiss() }
                            }
                        }
                }
            case .collection:
                NavigationView {
                    CollectionView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") { dismiss() }
                            }
                        }
                }
            case .wishlist:
                WishlistView()
            case .toyDetail(let imageName):
                if let toy = findToy(imageName: imageName) {
                    ToyDetailView(release: toy)
                } else {
                    ErrorView(message: "Toy not found")
                }
            case .series(let seriesName):
                if let series = findSeries(name: seriesName) {
                    SeriesDetailView(series: series)
                } else {
                    ErrorView(message: "Series not found")
                }
            case .event(let eventId):
                EventDetailView(eventId: eventId)
            case .shareCard:
                EnhancedShareCardGenerator()
            case .photoGallery(let imageName):
                if findToy(imageName: imageName) != nil {
                    NavigationView {
                        PhotoGalleryView(toyImageName: imageName)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Done") { dismiss() }
                                }
                            }
                    }
                } else {
                    ErrorView(message: "Toy not found")
                }
            }
        }
        .onDisappear {
            deepLinkManager.clearActiveDestination()
        }
    }
    
    private func findToy(imageName: String) -> ToyRelease? {
        return toySeries.flatMap { $0.releases }.first { $0.imageName == imageName }
    }
    
    private func findSeries(name: String) -> ToySeries? {
        return toySeries.first { $0.name.lowercased() == name.lowercased() }
    }
}

struct SeriesDetailView: View {
    let series: ToySeries
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Series Header
                    VStack(spacing: 12) {
                        Text(series.name)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                        
                        Text(series.chineseName)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.secondaryText(for: colorScheme))
                        
                        Text(series.description)
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.secondaryText(for: colorScheme))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    // Series Items
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 16) {
                        ForEach(series.releases) { release in
                            ReleaseItemView(release: release)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 100)
            }
            .background(AppColors.background(for: colorScheme))
            .navigationBarTitleDisplayMode(.inline)
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
    }
}

struct EventDetailView: View {
    let eventId: String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Event Header
                    VStack(spacing: 16) {
                        Image(systemName: "party.popper.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        
                        Text("Special Event")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
                        
                        Text("Event ID: \(eventId)")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.secondaryText(for: colorScheme))
                    }
                    .padding(.top, 40)
                    
                    // Event Content Based on ID
                    eventContent
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .background(AppColors.background(for: colorScheme))
            .navigationBarTitleDisplayMode(.inline)
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
    }
    
    @ViewBuilder
    private var eventContent: some View {
        switch eventId.lowercased() {
        case "summer-sale-2024":
            summerSaleEvent
        case "holiday-collection":
            holidayCollectionEvent
        case "new-series-launch":
            newSeriesLaunchEvent
        case "collector-appreciation":
            collectorAppreciationEvent
        default:
            genericEvent
        }
    }
    
    private var summerSaleEvent: some View {
        VStack(spacing: 20) {
            Text("🌞 Summer Sale 2024")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.orange)
            
            Text("Get ready for amazing discounts on your favorite Labubu series!")
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondaryText(for: colorScheme))
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                EventFeatureCard(
                    icon: "percent",
                    title: "Up to 30% Off",
                    description: "Selected series on sale"
                )
                
                EventFeatureCard(
                    icon: "gift.fill",
                    title: "Free Shipping",
                    description: "On orders over $50"
                )
                
                EventFeatureCard(
                    icon: "star.fill",
                    title: "Exclusive Items",
                    description: "Summer-themed limited editions"
                )
            }
        }
    }
    
    private var holidayCollectionEvent: some View {
        VStack(spacing: 20) {
            Text("🎄 Holiday Collection")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.red)
            
            Text("Discover magical holiday-themed Labubu figures!")
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondaryText(for: colorScheme))
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                EventFeatureCard(
                    icon: "snowflake",
                    title: "Winter Series",
                    description: "New winter-themed collection"
                )
                
                EventFeatureCard(
                    icon: "gift.fill",
                    title: "Gift Sets",
                    description: "Perfect for collectors"
                )
            }
        }
    }
    
    private var newSeriesLaunchEvent: some View {
        VStack(spacing: 20) {
            Text("🚀 New Series Launch")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.blue)
            
            Text("Be the first to collect from our newest series!")
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondaryText(for: colorScheme))
                .multilineTextAlignment(.center)
            
            Button(action: {
                // Navigate to explore view
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    DeepLinkManager.shared.navigate(to: .explore)
                }
            }) {
                Text("Explore New Series")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.gradient(for: colorScheme))
                    .clipShape(Capsule())
            }
        }
    }
    
    private var collectorAppreciationEvent: some View {
        VStack(spacing: 20) {
            Text("❤️ Collector Appreciation")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.red)
            
            Text("Thank you for being an amazing collector!")
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondaryText(for: colorScheme))
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                EventFeatureCard(
                    icon: "heart.fill",
                    title: "Loyalty Rewards",
                    description: "Special rewards for long-time collectors"
                )
                
                EventFeatureCard(
                    icon: "person.2.fill",
                    title: "Community Features",
                    description: "Connect with other collectors"
                )
            }
        }
    }
    
    private var genericEvent: some View {
        VStack(spacing: 20) {
            Text("🎉 Special Event")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.purple)
            
            Text("Something exciting is happening in the world of Labubu collecting!")
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondaryText(for: colorScheme))
                .multilineTextAlignment(.center)
            
            Text("Stay tuned for more details about this special event.")
                .font(.system(size: 14))
                .foregroundColor(AppColors.secondaryText(for: colorScheme))
                .multilineTextAlignment(.center)
        }
    }
}

struct EventFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.accent(for: colorScheme))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText(for: colorScheme))
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText(for: colorScheme))
            }
            
            Spacer()
        }
        .padding(16)
        .background(AppColors.cardBackground(for: colorScheme))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct ErrorView: View {
    let message: String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 48))
                    .foregroundColor(.orange)
                
                Text("Oops!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryText(for: colorScheme))
                
                Text(message)
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.secondaryText(for: colorScheme))
                    .multilineTextAlignment(.center)
                
                Button("Go Back") {
                    dismiss()
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.gradient(for: colorScheme))
                .clipShape(Capsule())
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accent(for: colorScheme))
                }
            }
        }
    }
}

extension View {
    func handleDeepLinks() -> some View {
        modifier(DeepLinkHandler())
    }
}
