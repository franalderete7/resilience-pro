//
//  WeekView.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//
import SwiftUI
import CloudKit

struct WeekView: View {
    var weekName: String
    var weekContent: [CKRecord.Reference] = []
    @ObservedObject var workoutsViewModel: WorkoutsViewModel

    init(weekContent: [CKRecord.Reference], weekName: String) {
        self.weekName = weekName
        self.weekContent = weekContent
        let workoutIds = weekContent.map { $0.recordID }
        self.workoutsViewModel = WorkoutsViewModel(workoutIDs: workoutIds)
    }

    var sortedWorkouts: [WorkoutModel] {
        workoutsViewModel.workouts.sorted { $0.name < $1.name }
    }

    var body: some View {
        ScrollView {
            if sortedWorkouts.isEmpty {
                ProgressView()
            } else {
                LazyVStack(alignment: .center, spacing: 40) {
                    ForEach(sortedWorkouts, id: \.self) { workout in
                        WorkoutCard(workout: workout)
                    }
                }
                .padding(.top, 50)
            }
        }
        .navigationTitle(weekName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

