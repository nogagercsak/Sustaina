//
//  DataModels.swift
//  Sustaina
//
//  Created by Noga Gercsak on 1/22/25.
//

import SwiftUICore

// Data Models
struct WasteClassification {
    let type: WasteType
    let details: String
}

enum WasteType {
    case recyclable
    case nonRecyclable
    case compostable
}

struct ImpactStats {
    var carbonSaved: Double
    var wasteDiverted: Double
    var treesPlanted: Int
    var communityRank: Int
}

// Helper Extensions
extension Color {
    static let ecoGreen = Color("EcoGreen")
    static let ecoBlue = Color("EcoBlue")
}
