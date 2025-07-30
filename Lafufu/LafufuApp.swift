//
//  LafufuApp.swift
//  Lafufu
//
//  Created by Raghav Sethi on 21/06/25.
//

import SwiftUI

@main
struct LafufuApp: App {
    @State private var hasCompletedOnboarding = UserDefaults.standard.string(forKey: "userName") != nil
    @State private var deepLinkEventId: String?
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .onOpenURL { url in
                        handleDeepLink(url)
                    }
            } else {
                OnboardingView()
                    .onOpenURL { url in
                        handleDeepLink(url)
                    }
            }
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        print("🔗 Deep link received in LafufuApp: \(url)")
        
        // Use the DeepLinkManager to handle all deep links
        DeepLinkManager.shared.handleURL(url)
    }
}

extension Notification.Name {
    static let navigateToEvent = Notification.Name("navigateToEvent")
}
