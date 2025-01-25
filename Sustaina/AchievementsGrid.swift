//
//  AchievementsGrid.swift
//  Sustaina
//
//  Created by Noga Gercsak on 1/25/25.
//

import SwiftUI

struct AchievementsGrid: View {
    let achievements: [Achievement]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
            ForEach(achievements) { achievement in
                VStack {
                    Image(systemName: achievement.icon) 
                        .font(.largeTitle)
                        .foregroundColor(.green)

                    Text(achievement.title)
                        .font(.headline)

                    Text("\(achievement.points) Points")
                        .font(.subheadline)
                }
                .padding()
                .background(achievement.isUnlocked ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
        }
        .padding()
    }
}
