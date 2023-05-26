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
        NavigationView {
            VStack {
                Spacer()
                Text("Hello \(vm.userName)!")
                    .font(.title)
                    .padding()
                Spacer()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
