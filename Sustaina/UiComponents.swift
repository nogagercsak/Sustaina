//
//  UiComponents.swift
//  Sustaina
//
//  Created by Noga Gercsak on 1/22/25.
//

import SwiftUI

struct ClimateRiskCard: View {
    var body: some View {
        VStack {
            Text("Local Climate Risk Assessment")
                .font(.headline)
            // Add more risk information...
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct InitiativeMarker: View {
    let initiative: Initiative
    
    var body: some View {
        VStack {
            Image(systemName: markerImage(for: initiative.type))
                .foregroundColor(.green)
            Text(initiative.title)
                .font(.caption)
        }
    }
    
    private func markerImage(for type: InitiativeType) -> String {
        switch type {
        case .solar: return "sun.max"
        case .reforestation: return "leaf"
        case .wasteCollection: return "trash"
        case .waterConservation: return "drop"
        }
    }
}

