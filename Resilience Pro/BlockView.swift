//
//  BlockView.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//
import SwiftUI
import CloudKit

struct BlockView: View {
    @State private var isExpanded: Bool = false
    var blockName: String
    var blockContent: [CKRecord.Reference] = []
    var series: Int64
    @ObservedObject var exercisesViewModel: ExercisesViewModel
    
    init(blockName: String, blockContent: [CKRecord.Reference], series: Int64) {
        self.blockName = blockName
        self.blockContent = blockContent
        self.series = series
        let exerciseIds = blockContent.map { $0.recordID }
        self.exercisesViewModel = ExercisesViewModel(exerciseIDs: exerciseIds)
    }
    
    var body: some View {
        VStack {
            DisclosureGroup(isExpanded: $isExpanded) {
                VStack {
                    Text("\(series) series")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if exercisesViewModel.isLoaded {
                        if exercisesViewModel.exercises.isEmpty {
                            Text("No exercises found")
                        } else {
                            ForEach(exercisesViewModel.exercises, id: \.self) { exercise in
                                ExerciseCard(exercise: exercise)
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
            } label: {
                Text(blockName)
                    .fontWeight(.bold)
                    .font(.system(size: 15))
            }

        }
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(8)
        .frame(width: UIScreen.main.bounds.width - 32)
        .opacity(0.9)
    }
}
