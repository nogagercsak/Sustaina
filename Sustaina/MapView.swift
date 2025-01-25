//
//  MapView.swift
//  Sustaina
//
//  Created by Noga Gercsak on 1/22/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                annotationItems: viewModel.initiatives) { initiative in
                MapAnnotation(coordinate: initiative.coordinate) {
                    InitiativeMarker(initiative: initiative)
                }
            }
            .navigationTitle("Climate Initiatives")
            .overlay(
                ClimateRiskCard()
            )
        }
    }
}

// Initiative Models
struct Initiative: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let type: InitiativeType
}

enum InitiativeType {
    case solar
    case reforestation
    case wasteCollection
    case waterConservation
}

// MapViewModel.swift
class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var initiatives: [Initiative] = []
    
    init() {
        loadInitiatives()
    }
    
    private func loadInitiatives() {
        // Mock data for initiatives
        initiatives = [
            Initiative(title: "Community Solar Project",
                      description: "Solar panel installation for community center",
                      coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                      type: .solar),
            // Add more initiatives...
        ]
    }
}
