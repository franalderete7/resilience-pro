//
//  File.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//
import SwiftUI
import Combine
import CloudKit

extension CKAsset {
    var image: UIImage? {
        get {
            if let fileURL = self.fileURL {
                do {
                    let imageData = try Data(contentsOf: fileURL)
                    return UIImage(data: imageData)
                } catch {
                    print("Error loading image data: \(error)")
                }
            }
            return nil
        }
    }
}


struct ProgramsView: View {
    @State var isLoading: Bool = true
    @StateObject private var programs = ProgramsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    if isLoading {
                        ProgressView()
                    }
                    ForEach(programs.programs, id: \.self) { program in
                        ProgramCard(program: program)
                    }
                }
                .padding(.top, 30)
            }
            .navigationTitle("Programas")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isLoading = !programs.isLoaded
            }
            .onReceive(programs.$isLoaded) { isLoaded in
                isLoading = !isLoaded
            }
        }
    }
}
