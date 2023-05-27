//
//  BlockView.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//

import SwiftUI

struct BlockView: View {
    @State private var isExpanded: Bool = false
    var block: BlockModel
    @ObservedObject var exercisesViewModel: ExercisesViewModel

    init(block: BlockModel) {
        self.block = block
        let exerciseIds = block.exercises.map { $0.recordID }
        self.exercisesViewModel = ExercisesViewModel(exerciseIDs: exerciseIds)
    }

    var body: some View {
        VStack {
            DisclosureGroup(isExpanded: $isExpanded, content: {
                    ForEach(exercisesViewModel.exercises, id: \.self) { exercise in
                        ExerciseCard(exercise: exercise)
                    }
            }, label: {
                Text(block.name)
            })
        }
        .padding()
        .background(Color(.systemGray6))
        .foregroundColor(.white)
        .cornerRadius(8)
        .frame(width: UIScreen.main.bounds.width - 32)
        .opacity(0.9)
    }
}
