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
    private func getVideoFileUrl(from urlString: String) -> URL {
        guard URL(string: urlString) != nil else {
                fatalError("Invalid video URL: \(urlString)")
            }
            
            let videoFilename = "\(exercise.name).mp4" // Use exercise name for filename
            let videoFileUrl = FileManager.default.temporaryDirectory.appendingPathComponent(videoFilename)
            
            return videoFileUrl
        }
    
    private func downloadVideoToCache(from url: URL, saveTo saveUrl: URL) {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) { (location, response, error) in
            if let location = location {
                do {
                    try FileManager.default.moveItem(at: location, to: saveUrl)
                    DispatchQueue.main.async {
                        self.player = AVPlayer(url: saveUrl)
                        self.isVideoReady = true
                        self.player.play()
                    }
                    print("Video successfully cached at: \(saveUrl)")
                } catch {
                    print("Failed to move video file to cache directory: \(error)")
                }
            }
        }
        downloadTask.resume()
    }
    private func checkVideoCache() {
            let videoFileUrl = getVideoFileUrl(from: videoUrl)
            let cachedVideoUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(videoFileUrl.lastPathComponent)
            
            if cachedVideoUrl.isFileURL && FileManager.default.fileExists(atPath: cachedVideoUrl.path) {
                self.player = AVPlayer(url: cachedVideoUrl)
                self.isVideoReady = true
                print("Serving video from cache")
            } else {
                downloadVideoToCache(from: URL(string: videoUrl)!, saveTo: cachedVideoUrl)
                print("Serving video from URL")
            }
        }
}


struct VideoPlayer : UIViewControllerRepresentable {
    
    @Binding var player : AVPlayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayer>) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resize
        player.isMuted = true
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<VideoPlayer>) {
        
    }
}
