//
//  MainTabView.swift
//  FMS
//
//  Created by Prince on 11/02/25.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
           HomeView()
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationViewScreen()
                .tabItem {
                    Image(systemName: "map")
                    Text("Navigation")
                }
            
            ProfileView() // ✅ Replacing Text with ProfileView
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    MainTabView()
}


