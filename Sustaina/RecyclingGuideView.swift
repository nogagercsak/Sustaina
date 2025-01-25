//
//  RecyclingGuideView.swift
//  Sustaina
//
//  Created by Noga Gercsak on 1/25/25.
//

import SwiftUI

struct RecyclingGuideView: View {
    let classification: WasteClassification

    var body: some View {
        VStack {
            Text("Recycling Guide")
                .font(.headline)
                .padding(.bottom, 8)

            Text("Item: \(classification.details)")
                .font(.subheadline)

            if classification.type == .recyclable {
                Text("This item is recyclable! 🎉")
                    .foregroundColor(.green)
            } else {
                Text("This item is not recyclable.")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        .shadow(radius: 4)
    }
}
