//
//  ContentView.swift
//  Sustaina
//
//  Created by Noga Gercsak on 1/22/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(0)
            
            ScannerView()
                .tabItem {
                    Image(systemName: "camera")
                    Text("Scan")
                }
                .tag(1)
            
            ImpactView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Impact")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(3)
        }
    }
}
