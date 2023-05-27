//
//  WeekView.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//
import SwiftUI

struct WeekView: View {
    var week: WeekModel
    @ObservedObject var workoutsViewModel: WorkoutsViewModel

    init(week: WeekModel) {
        self.week = week
        let workoutIds = week.workouts.map { $0.recordID }
        self.workoutsViewModel = WorkoutsViewModel(workoutIDs: workoutIds)
    }

    var body: some View {
        VStack(spacing: 10) {
                ForEach(workoutsViewModel.workouts, id: \.self) { workout in
                    WorkoutCard(workout: workout)
                }
        }
        .padding(4)
        .navigationTitle(week.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


