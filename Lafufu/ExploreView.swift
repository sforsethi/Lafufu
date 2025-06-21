//
//  ExploreView.swift
//  Lafufu
//
//  Created by Raghav Sethi on 21/06/25.
//

import SwiftUI

struct ExploreView: View {
    @State private var expandedSeries: Set<UUID> = Set(labubuSeries.map { $0.id })
    
    var body: some View {
        VStack(spacing: 0) {
            // Explore title
            HStack {
                Text("All Series")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            
            // Series list
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(labubuSeries) { series in
                        SeriesCardView(
                            series: series,
                            isExpanded: expandedSeries.contains(series.id)
                        ) {
                            if expandedSeries.contains(series.id) {
                                expandedSeries.remove(series.id)
                            } else {
                                expandedSeries.insert(series.id)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 100)
            }
        }
    }
}

struct CollectionItemView: View {
    let imageName: String
    let title: String
    let isVisible: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(height: 180)
                
                if isVisible {
                    // Placeholder for actual Labubu images
                    ZStack {
                        // Base Labubu shape
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(hex: "F5E6D3"))
                            .frame(width: 100, height: 120)
                        
                        // Simple Labubu representation
                        VStack(spacing: 4) {
                            // Ears
                            HStack(spacing: 20) {
                                Ellipse()
                                    .fill(Color(hex: "E6D3B7"))
                                    .frame(width: 12, height: 20)
                                Ellipse()
                                    .fill(Color(hex: "E6D3B7"))
                                    .frame(width: 12, height: 20)
                            }
                            .offset(y: -10)
                            
                            // Head
                            Circle()
                                .fill(Color(hex: "F5E6D3"))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    VStack(spacing: 2) {
                                        // Eyes
                                        HStack(spacing: 8) {
                                            Circle()
                                                .fill(Color.black)
                                                .frame(width: 8, height: 8)
                                            Circle()
                                                .fill(Color.black)
                                                .frame(width: 8, height: 8)
                                        }
                                        
                                        // Mouth
                                        if imageName == "labubu1" || imageName == "labubu3" {
                                            Rectangle()
                                                .fill(Color.black)
                                                .frame(width: 16, height: 2)
                                                .cornerRadius(1)
                                        } else if imageName == "labubu4" {
                                            // Skull mouth
                                            HStack(spacing: 2) {
                                                Rectangle()
                                                    .fill(Color.black)
                                                    .frame(width: 2, height: 8)
                                                Rectangle()
                                                    .fill(Color.black)
                                                    .frame(width: 2, height: 8)
                                                Rectangle()
                                                    .fill(Color.black)
                                                    .frame(width: 2, height: 8)
                                            }
                                        }
                                    }
                                )
                            
                            // Body
                            if imageName == "labubu2" {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black)
                                    .frame(width: 40, height: 30)
                            } else if imageName == "labubu3" {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: "87CEEB"))
                                    .frame(width: 40, height: 30)
                                    .overlay(
                                        HStack(spacing: 4) {
                                            Rectangle()
                                                .fill(Color.white)
                                                .frame(width: 2, height: 20)
                                            Rectangle()
                                                .fill(Color.white)
                                                .frame(width: 2, height: 20)
                                        }
                                    )
                            } else if imageName == "labubu4" {
                                VStack(spacing: 2) {
                                    // Ribcage
                                    ForEach(0..<3, id: \.self) { _ in
                                        HStack(spacing: 3) {
                                            Rectangle()
                                                .fill(Color.black)
                                                .frame(width: 20, height: 2)
                                            Rectangle()
                                                .fill(Color.black)
                                                .frame(width: 20, height: 2)
                                        }
                                    }
                                }
                                .frame(width: 40, height: 30)
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: "F5E6D3"))
                                    .frame(width: 40, height: 30)
                            }
                        }
                    }
                } else {
                    // Blurred/invisible state
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(hex: "F5E6D3"))
                            .frame(width: 100, height: 120)
                            .blur(radius: 8)
                            .opacity(0.6)
                    }
                }
            }
            
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
                .opacity(isVisible ? 1.0 : 0.6)
        }
    }
}

struct ReleaseItemView: View {
    let release: LabubuRelease
    @State private var showingDetail = false
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(height: 140)
                
                VStack(spacing: 4) {
                    // Ears
                    HStack(spacing: 16) {
                        Ellipse()
                            .fill(Color(hex: "F5E6D3"))
                            .frame(width: 10, height: 16)
                        Ellipse()
                            .fill(Color(hex: "F5E6D3"))
                            .frame(width: 10, height: 16)
                    }
                    .offset(y: -8)
                    
                    // Head with fruit theme color
                    Circle()
                        .fill(Color(hex: release.color).opacity(0.3))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(Color(hex: release.color), lineWidth: 2)
                        )
                        .overlay(
                            VStack(spacing: 2) {
                                // Eyes
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 6, height: 6)
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 6, height: 6)
                                }
                                
                                // Mouth
                                Capsule()
                                    .fill(Color.black)
                                    .frame(width: 12, height: 2)
                            }
                        )
                    
                    // Themed accessory based on fruit
                    fruitAccessory(for: release.imageName)
                }
            }
            
            VStack(spacing: 2) {
                Text(release.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "4A5C6A"))
                    .multilineTextAlignment(.center)
                
                Text(release.chineseName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "7A8A9A"))
                    .multilineTextAlignment(.center)
            }
        }
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            LabubuDetailView(release: release)
        }
    }
    
    @ViewBuilder
    private func fruitAccessory(for imageName: String) -> some View {
        switch imageName {
        case "lemon":
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.yellow.opacity(0.7))
                .frame(width: 30, height: 20)
        case "banana":
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.orange.opacity(0.7))
                .frame(width: 25, height: 8)
        case "pineapple":
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.yellow.opacity(0.6))
                .frame(width: 28, height: 18)
        case "orange":
            Circle()
                .fill(Color.orange.opacity(0.7))
                .frame(width: 20, height: 20)
        case "coconut":
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.4))
                .frame(width: 32, height: 16)
        case "grape":
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.purple.opacity(0.6))
                .frame(width: 26, height: 18)
        case "pear":
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.green.opacity(0.5))
                .frame(width: 28, height: 20)
        case "strawberry":
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.pink.opacity(0.7))
                .frame(width: 24, height: 16)
        case "cherry":
            HStack(spacing: 2) {
                Circle()
                    .fill(Color.red.opacity(0.7))
                    .frame(width: 10, height: 10)
                Circle()
                    .fill(Color.red.opacity(0.7))
                    .frame(width: 10, height: 10)
            }
        case "kiwi":
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.green.opacity(0.4))
                .frame(width: 30, height: 15)
        case "watermelon":
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.green.opacity(0.6))
                .frame(width: 26, height: 18)
        case "peach":
            Circle()
                .fill(Color.pink.opacity(0.5))
                .frame(width: 22, height: 22)
        case "love":
            Circle()
                .fill(Color.pink.opacity(0.7))
                .frame(width: 20, height: 20)
        case "happiness":
            Circle()
                .fill(Color.orange.opacity(0.7))
                .frame(width: 20, height: 20)
        case "loyalty":
            Circle()
                .fill(Color.yellow.opacity(0.7))
                .frame(width: 20, height: 20)
        case "serenity":
            Circle()
                .fill(Color.green.opacity(0.7))
                .frame(width: 20, height: 20)
        case "hope":
            Circle()
                .fill(Color.blue.opacity(0.7))
                .frame(width: 20, height: 20)
        case "luck":
            Circle()
                .fill(Color.purple.opacity(0.7))
                .frame(width: 20, height: 20)
        case "surprise_shake":
            VStack(spacing: 2) {
                // Santa hat
                Triangle()
                    .fill(Color.red)
                    .frame(width: 8, height: 6)
                // Coke bottle
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.black)
                    .frame(width: 6, height: 12)
            }
        case "happy_factor":
            VStack(spacing: 2) {
                // Winter hat
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white)
                    .frame(width: 10, height: 4)
                // Coke cup
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.red)
                    .frame(width: 8, height: 10)
            }
        case "seen_her":
            VStack(spacing: 1) {
                // Flower crown
                HStack(spacing: 1) {
                    Circle().fill(Color.pink).frame(width: 3, height: 3)
                    Circle().fill(Color.yellow).frame(width: 3, height: 3)
                    Circle().fill(Color.pink).frame(width: 3, height: 3)
                }
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.pink.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "follow_light":
            VStack(spacing: 1) {
                // Light/star element
                Star()
                    .fill(Color.yellow)
                    .frame(width: 8, height: 8)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.yellow.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "painters_help":
            VStack(spacing: 1) {
                // Paint palette
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.blue.opacity(0.8))
                    .frame(width: 10, height: 6)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "over_there":
            VStack(spacing: 1) {
                // Pointing arrow
                Triangle()
                    .fill(Color.cyan)
                    .frame(width: 8, height: 6)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.cyan.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "see_you":
            VStack(spacing: 1) {
                // Balloon
                Circle()
                    .fill(Color.purple.opacity(0.8))
                    .frame(width: 6, height: 6)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.purple.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "great_discovery":
            VStack(spacing: 1) {
                // Magnifying glass
                Circle()
                    .stroke(Color.green, lineWidth: 1)
                    .frame(width: 6, height: 6)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.green.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "move_bravely":
            VStack(spacing: 1) {
                // Shield
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.orange)
                    .frame(width: 6, height: 8)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.orange.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "careless_hunter":
            VStack(spacing: 1) {
                // Camping tent
                Triangle()
                    .fill(Color.orange)
                    .frame(width: 8, height: 6)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.orange.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "winds_guidance":
            VStack(spacing: 1) {
                // Wind swirl
                Circle()
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(width: 6, height: 6)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "found_it":
            VStack(spacing: 1) {
                // Treasure chest
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.green)
                    .frame(width: 8, height: 6)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.green.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "heart_maze":
            VStack(spacing: 1) {
                // Heart shape
                Heart()
                    .fill(Color.pink)
                    .frame(width: 8, height: 7)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.pink.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "little_bird":
            VStack(spacing: 1) {
                // Star crown
                Star()
                    .fill(Color.yellow)
                    .frame(width: 6, height: 6)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.purple.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "zone_out":
            VStack(spacing: 1) {
                // Meditation symbol
                Circle()
                    .fill(Color.green.opacity(0.8))
                    .frame(width: 6, height: 6)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.green.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "ab_roller":
            VStack(spacing: 1) {
                // Exercise equipment
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.pink)
                    .frame(width: 8, height: 4)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.pink.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "sweating":
            VStack(spacing: 1) {
                // Sweat drops
                HStack(spacing: 1) {
                    Circle().fill(Color.blue).frame(width: 2, height: 2)
                    Circle().fill(Color.blue).frame(width: 3, height: 3)
                    Circle().fill(Color.blue).frame(width: 2, height: 2)
                }
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.purple.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "confident":
            VStack(spacing: 1) {
                // Confidence sparkles
                HStack(spacing: 1) {
                    Star().fill(Color.pink).frame(width: 3, height: 3)
                    Star().fill(Color.pink).frame(width: 4, height: 4)
                    Star().fill(Color.pink).frame(width: 3, height: 3)
                }
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.pink.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "stretch_out":
            VStack(spacing: 1) {
                // Stretch lines
                HStack(spacing: 1) {
                    Rectangle().fill(Color.blue).frame(width: 1, height: 6)
                    Rectangle().fill(Color.blue).frame(width: 1, height: 8)
                    Rectangle().fill(Color.blue).frame(width: 1, height: 6)
                }
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "cozy_time":
            VStack(spacing: 1) {
                // Cozy elements
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.green)
                    .frame(width: 8, height: 5)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.green.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "sleepy_mode":
            VStack(spacing: 1) {
                // Coffee cup
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.brown)
                    .frame(width: 6, height: 6)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "happy_stretch":
            VStack(spacing: 1) {
                // Happy face
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 6, height: 6)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue.opacity(0.7))
                    .frame(width: 16, height: 8)
            }
        case "soymilk":
            VStack(spacing: 2) {
                Circle()
                    .stroke(Color.brown, lineWidth: 2)
                    .frame(width: 12, height: 12)
                VStack(spacing: 1) {
                    // Macaron layers
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(hex: "F5E6D3"))
                        .frame(width: 14, height: 3)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: 12, height: 2)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(hex: "F5E6D3"))
                        .frame(width: 14, height: 3)
                }
            }
        case "lychee_berry":
            VStack(spacing: 2) {
                Circle()
                    .stroke(Color.brown, lineWidth: 2)
                    .frame(width: 12, height: 12)
                VStack(spacing: 1) {
                    // Pink macaron layers
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.pink)
                        .frame(width: 14, height: 3)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: 12, height: 2)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.pink)
                        .frame(width: 14, height: 3)
                }
            }
        case "green_grape":
            VStack(spacing: 2) {
                Circle()
                    .stroke(Color.brown, lineWidth: 2)
                    .frame(width: 12, height: 12)
                VStack(spacing: 1) {
                    // Green macaron layers
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.green)
                        .frame(width: 14, height: 3)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: 12, height: 2)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.green)
                        .frame(width: 14, height: 3)
                }
            }
        case "sea_salt_coconut":
            VStack(spacing: 2) {
                Circle()
                    .stroke(Color.brown, lineWidth: 2)
                    .frame(width: 12, height: 12)
                VStack(spacing: 1) {
                    // Blue macaron layers
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.blue)
                        .frame(width: 14, height: 3)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: 12, height: 2)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.blue)
                        .frame(width: 14, height: 3)
                }
            }
        case "toffee":
            VStack(spacing: 2) {
                Circle()
                    .stroke(Color.brown, lineWidth: 2)
                    .frame(width: 12, height: 12)
                VStack(spacing: 1) {
                    // Brown macaron layers
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.brown)
                        .frame(width: 14, height: 3)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: 12, height: 2)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.brown)
                        .frame(width: 14, height: 3)
                }
            }
        case "sesame_bean":
            VStack(spacing: 2) {
                Circle()
                    .stroke(Color.brown, lineWidth: 2)
                    .frame(width: 12, height: 12)
                VStack(spacing: 1) {
                    // Gray macaron layers
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray)
                        .frame(width: 14, height: 3)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: 12, height: 2)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray)
                        .frame(width: 14, height: 3)
                }
            }
        case "sisi":
            VStack(spacing: 2) {
                Circle()
                    .stroke(Color.brown, lineWidth: 2)
                    .frame(width: 12, height: 12)
                VStack(spacing: 1) {
                    // Closed peaceful eyes
                    HStack(spacing: 4) {
                        Rectangle().fill(Color.black).frame(width: 6, height: 1)
                        Rectangle().fill(Color.black).frame(width: 6, height: 1)
                    }
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(hex: "F5DEB3").opacity(0.7))
                        .frame(width: 16, height: 8)
                }
            }
        case "hehe":
            VStack(spacing: 2) {
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 12, height: 12)
                VStack(spacing: 1) {
                    // Winking eyes
                    HStack(spacing: 4) {
                        Circle().fill(Color.black).frame(width: 3, height: 3)
                        Rectangle().fill(Color.black).frame(width: 6, height: 1)
                    }
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.7))
                        .frame(width: 16, height: 8)
                }
            }
        case "baba":
            VStack(spacing: 2) {
                Circle()
                    .stroke(Color.brown, lineWidth: 2)
                    .frame(width: 12, height: 12)
                VStack(spacing: 1) {
                    // Wide open eyes
                    HStack(spacing: 4) {
                        Circle().fill(Color.black).frame(width: 4, height: 4)
                        Circle().fill(Color.black).frame(width: 4, height: 4)
                    }
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(hex: "DEB887").opacity(0.7))
                        .frame(width: 16, height: 8)
                }
            }
        case "zizi":
            VStack(spacing: 2) {
                Circle()
                    .stroke(Color.purple, lineWidth: 2)
                    .frame(width: 12, height: 12)
                VStack(spacing: 1) {
                    // Sleepy eyes
                    HStack(spacing: 4) {
                        Rectangle().fill(Color.black).frame(width: 5, height: 1)
                        Rectangle().fill(Color.black).frame(width: 5, height: 1)
                    }
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.purple.opacity(0.7))
                        .frame(width: 16, height: 8)
                }
            }
        case "ququ":
            VStack(spacing: 2) {
                Circle()
                    .stroke(Color.green, lineWidth: 2)
                    .frame(width: 12, height: 12)
                VStack(spacing: 1) {
                    // Bright curious eyes
                    HStack(spacing: 4) {
                        Circle().fill(Color.blue).frame(width: 4, height: 4)
                        Circle().fill(Color.blue).frame(width: 4, height: 4)
                    }
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.green.opacity(0.7))
                        .frame(width: 16, height: 8)
                }
            }
        case "dada":
            VStack(spacing: 2) {
                Circle()
                    .stroke(Color.pink, lineWidth: 2)
                    .frame(width: 12, height: 12)
                VStack(spacing: 1) {
                    // Cheerful eyes with blush
                    HStack(spacing: 4) {
                        Circle().fill(Color.black).frame(width: 3, height: 3)
                        Circle().fill(Color.black).frame(width: 3, height: 3)
                    }
                    // Blush marks
                    HStack(spacing: 8) {
                        Circle().fill(Color.pink).frame(width: 3, height: 3)
                        Circle().fill(Color.pink).frame(width: 3, height: 3)
                    }
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.pink.opacity(0.7))
                        .frame(width: 16, height: 8)
                }
            }
        
        default:
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 28, height: 18)
        }
    }
}
 
struct SeriesCardView: View {
    let series: LabubuSeries
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Series header
            Button(action: onToggle) {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(series.name)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                            
                            Text(series.chineseName)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Text("\(series.releases.count)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: series.color))
                            
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Series description
                    HStack {
                        Text(series.description)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expanded releases grid
            if isExpanded {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 16) {
                    ForEach(series.releases) { release in
                        ReleaseItemView(release: release)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                .offset(y: -8) // Slight overlap with header
            }
        }
    }
}
