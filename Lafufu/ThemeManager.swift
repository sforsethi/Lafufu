//
//  ThemeManager.swift
//  Lafufu
//
//  Enhanced theming system with dark mode support
//

import SwiftUI
import UIKit

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
    
    init() {
        // Detect system appearance
        isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
        
        // Listen for system appearance changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(systemAppearanceChanged),
            name: UIScreen.brightnessDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func systemAppearanceChanged() {
        DispatchQueue.main.async {
            self.isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

struct AppColors {
    static func background(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "1C1C1E") : Color(hex: "F0F0F0")
    }
    
    static func cardBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "2C2C2E") : Color.white
    }
    
    static func primaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    static func secondaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "AEAEB2") : Color.gray
    }
    
    static func accent(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "667eea") : Color(hex: "667eea")
    }
    
    static func gradient(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "667eea").opacity(0.8), Color(hex: "764ba2").opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.orange
    static let info = Color.blue
}

struct HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}