//
//  ExerciseCard.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 27/05/2023.
//


import SwiftUI

struct ExerciseCard: View {
    var exercise: ExerciseModel
    
    var body: some View {
        HStack {
            Image(uiImage: exercise.image.image ?? UIImage())
                .resizable()
                .frame(width: 85, height: 55)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(6)
            VStack(spacing: 1) {
                Text(exercise.name)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 14))
                HStack(spacing: 1) {
                    Text("\(exercise.reps) reps")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    
                    Text("descanso \(exercise.rest) segundos")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top,5)
    }
}
