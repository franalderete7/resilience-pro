//
//  WorkoutView.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//

import SwiftUI

struct WorkoutCard: View {
    var workout: WorkoutModel
    
    var body: some View {
        HStack(spacing: 10) {
            Text(workout.name)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 50)
                .padding(14)
            Image(systemName: "chevron.right")
                .foregroundColor(Color(.systemGray5))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(14)
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
        .opacity(0.9)
    }
}
