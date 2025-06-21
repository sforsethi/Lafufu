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
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingView()
            }
        }
    }
}
