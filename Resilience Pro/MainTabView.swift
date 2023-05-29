//
//  MainTab.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//

import SwiftUI
struct MainTabView: View {
    var body: some View {
        TabView {
            ProgramsView()
                .tabItem {
                    Label("Programas", systemImage: "dumbbell.fill")
                }
            UploadExerciseView()
                .tabItem {
                    Label("Ejercicios", systemImage: "square.and.arrow.up")
                }
            UserProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
        }
    }
}
