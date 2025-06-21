//
//  OnboardingView.swift
//  Lafufu
//
//  Created by Raghav Sethi on 21/06/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var userName: String = ""
    @State private var showingMainApp = false
    @State private var animateAnimals = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "FFE4E1"),
                    Color(hex: "E6E6FA"),
                    Color(hex: "F0F8FF")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating animals background
            ZStack {
                // Various cute animals scattered around
                FloatingAnimal(emoji: "🐰", position: CGPoint(x: 80, y: 150), delay: 0)
                FloatingAnimal(emoji: "🐱", position: CGPoint(x: 300, y: 200), delay: 0.5)
                FloatingAnimal(emoji: "🐼", position: CGPoint(x: 50, y: 400), delay: 1.0)
                FloatingAnimal(emoji: "🦊", position: CGPoint(x: 320, y: 450), delay: 1.5)
                FloatingAnimal(emoji: "🐻", position: CGPoint(x: 150, y: 600), delay: 2.0)
                FloatingAnimal(emoji: "🐨", position: CGPoint(x: 280, y: 650), delay: 2.5)
                FloatingAnimal(emoji: "🐸", position: CGPoint(x: 100, y: 300), delay: 3.0)
                FloatingAnimal(emoji: "🐹", position: CGPoint(x: 250, y: 350), delay: 3.5)
                FloatingAnimal(emoji: "🦔", position: CGPoint(x: 180, y: 500), delay: 4.0)
                FloatingAnimal(emoji: "🐷", position: CGPoint(x: 340, y: 320), delay: 4.5)
            }
            .opacity(0.3)
            .scaleEffect(animateAnimals ? 1.1 : 0.9)
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateAnimals)
            
            // Main content
            VStack(spacing: 40) {
                Spacer()
                
                // App icon and welcome
                VStack(spacing: 24) {
                    // Large app icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.8))
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        Text("🦔")
                            .font(.system(size: 60))
                    }
                    .scaleEffect(animateAnimals ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateAnimals)
                    
                    VStack(spacing: 12) {
                        Text("Welcome to")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.black.opacity(0.7))
                        
                        Text("Toy Collector")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                
                // Name input section
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("What should we call you?")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        Text("Let's personalize your collection experience!")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    
                    // Name input field
                    VStack(spacing: 16) {
                        TextField("Enter your name", text: $userName)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
                            )
                        
                        // Continue button
                        Button(action: {
                            if !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                UserDefaults.standard.set(userName.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "userName")
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    showingMainApp = true
                                }
                            }
                        }) {
                            HStack(spacing: 12) {
                                Text("Let's Start Collecting!")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(hex: "FF6B6B"),
                                        Color(hex: "FF8E8E")
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: Color(hex: "FF6B6B").opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .disabled(userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                        .scaleEffect(userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.95 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: userName.isEmpty)
                    }
                    .padding(.horizontal, 32)
                }
                
                Spacer()
                
                // Fun tagline
                Text("Start your magical toy collection journey! 🎉")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
            }
        }
        .onAppear {
            animateAnimals = true
        }
        .fullScreenCover(isPresented: $showingMainApp) {
            MainAppView()
        }
    }
}

struct FloatingAnimal: View {
    let emoji: String
    let position: CGPoint
    let delay: Double
    @State private var isFloating = false
    
    var body: some View {
        Text(emoji)
            .font(.system(size: 40))
            .position(position)
            .offset(y: isFloating ? -20 : 20)
            .animation(
                .easeInOut(duration: 2.5)
                .repeatForever(autoreverses: true)
                .delay(delay),
                value: isFloating
            )
            .onAppear {
                isFloating = true
            }
    }
}

struct MainAppView: View {
    var body: some View {
        ContentView()
    }
}

#Preview {
    OnboardingView()
}