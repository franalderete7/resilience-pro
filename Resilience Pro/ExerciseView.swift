//
//  ExerciseView.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 27/05/2023.
//
//
//  ExerciseView.swift
//  Citadel Pro
//
//  Created by Francisco Alderete on 03/05/2023.
//
import SwiftUI
import AVKit
import CloudKit
import UserNotifications

struct ExerciseView: View {
    
    var exercise: ExerciseModel
    var videoUrl: String 
    @State var player = AVPlayer()
    @State var isplaying = false
    @State var isVideoReady = false
    
    init(exercise: ExerciseModel, videoUrl: String) {
        self.exercise = exercise
        self.videoUrl = videoUrl
        
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    var body: some View {
        VStack {
            if isVideoReady {
                VideoPlayer(player: $player)
                    .frame(height: UIScreen.main.bounds.height / 3.5)
                    .onTapGesture {
                        if self.isplaying {
                            self.player.pause()
                        } else {
                            self.player.play()
                        }
                        self.isplaying.toggle()
                    }
            } else {
                GeometryReader { geometry in
                    ProgressView()
                        .frame(width: geometry.size.width, height: UIScreen.main.bounds.height / 3.5)
                        .background(Color.black)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                }
                .frame(height: UIScreen.main.bounds.height / 3.5)
            }
            
            GeometryReader{_ in
                VStack{
                    Text(exercise.name)
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 1) {
                        Text("\(exercise.reps) reps - ")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                        
                        Text("descanso \(exercise.rest) segundos")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    VStack(spacing: 2) {
                        Text("Dificultad")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(exercise.difficulty.uppercased())
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top, 10)
                    VStack(spacing: 2) {
                        Text("Descripción")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(exercise.description.uppercased())
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top, 10)
                }
                .padding(15)
            }
         }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .onAppear {
            checkVideoCache()
            self.player.isMuted = true
            self.player.play()
            self.isplaying = true
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { _ in
                self.player.seek(to: .zero)
                self.player.play()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
            
            self.player.seek(to: .zero)
            self.player.pause()
            self.isplaying = false
        }
        .onReceive(player.publisher(for: \.status)) { status in
            if status == .readyToPlay {
                isVideoReady = true
            }
        }
    }
}

