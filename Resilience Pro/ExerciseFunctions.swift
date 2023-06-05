//
//  ExerciseFunctions.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 05/06/2023.
//

import AVKit

extension ExerciseView {
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
    
    public func checkVideoCache() {
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

