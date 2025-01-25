//
//  ImpactView.swift
//  Sustaina
//
//  Created by Noga Gercsak on 1/22/25.
//

import SwiftUI

struct ImpactView: View {
    @StateObject private var viewModel = ImpactViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ImpactStatsCard(stats: viewModel.stats)
                    
                    CommunityProgressView(progress: 45.5)

                    
                    AchievementsGrid(achievements: viewModel.achievements)
                }
                .padding()
            }
            .navigationTitle("Your Impact")
        }
    }
}
