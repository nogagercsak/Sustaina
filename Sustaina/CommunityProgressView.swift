//
//  CommunityProgressView.swift
//  Sustaina
//
//  Created by Noga Gercsak on 1/25/25.
//

import SwiftUI

struct CommunityProgressView: View {
    let progress: Double

    var body: some View {
        VStack {
            Text("Community Progress")
                .font(.headline)
            ProgressView(value: progress, total: 1.0) // Assuming progress is normalized (0.0 to 1.0)
                .progressViewStyle(LinearProgressViewStyle())
            Text("\(Int(progress * 100))% completed")
                .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

