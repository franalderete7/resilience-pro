//
//  UserProfileClass.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//

import SwiftUI

struct UserProfileView: View {
    
    @StateObject private var vm = UserProfile()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Hola \(vm.userName)!")
                    .font(.title)
                    .padding()
                Spacer()
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
