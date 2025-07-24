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
        print("🔗 Deep link received: \(url)")
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { 
            print("❌ Failed to parse URL components")
            return 
        }
        
        print("📍 Path: \(components.path)")
        print("🔍 Query items: \(components.queryItems ?? [])")
        
        let pathComponents = components.path.components(separatedBy: "/").filter { !$0.isEmpty }
        
        if pathComponents.count >= 2 && pathComponents[0] == "events" {
            let eventId = pathComponents[1]
            print("✅ Event ID found: \(eventId)")
            deepLinkEventId = eventId
            NotificationCenter.default.post(name: .navigateToEvent, object: eventId)
        } else if components.path == "/event" {
            if let eventId = components.queryItems?.first(where: { $0.name == "id" })?.value {
                print("✅ Event ID found from query: \(eventId)")
                deepLinkEventId = eventId
                NotificationCenter.default.post(name: .navigateToEvent, object: eventId)
            } else {
                print("❌ No event ID found in query parameters")
            }
        } else {
            print("❌ Path doesn't match expected format. Expected: /events/{event-id}")
        }
    }
}

extension Notification.Name {
    static let navigateToEvent = Notification.Name("navigateToEvent")
}
