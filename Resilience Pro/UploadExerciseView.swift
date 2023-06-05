//
//  UploadExerciseView.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 28/05/2023.
//
import SwiftUI
import CloudKit

struct UploadExerciseView: View {
    @State private var name = ""
    @State private var description = ""
    @State private var difficulty = ""
    @State private var reps = 0
    @State private var rest = 0
    
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    
    @State private var isVideoPickerPresented = false
    @State private var selectedVideoURL: URL?
    
    @Environment(\.presentationMode) var presentationMode
    
    func uploadExercise() {
        guard let image = selectedImage, let videoURL = selectedVideoURL else {
            // Handle error, both image and video should be selected
            return
        }
        
        guard let imageAsset = createCKAsset(from: image) else {
            // Handle error, failed to create CKAsset from image
            return
        }
        
        guard let videoAsset = createCKAsset(from: videoURL) else {
            // Handle error, failed to create CKAsset from video URL
            return
        }
        
        let exercise = ExerciseModel(
            name: name,
            description: description,
            difficulty: difficulty,
            image: imageAsset,
            video: videoAsset,
            reps: reps,
            rest: rest
        )
        
        CloudKitUtility.add(item: exercise!) { result in
            switch result {
            case .success:
                // Exercise uploaded successfully
                // Perform any necessary UI updates or navigate to a different screen
                print("Exercise uploaded successfully.")
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                // Handle error during exercise upload
                print("Exercise upload failed: \(error)")
            }
        }
    }
    
    func createCKAsset(from image: UIImage) -> CKAsset? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            // Failed to convert image to data
            return nil
        }
        
        let tempDirectoryURL = FileManager.default.temporaryDirectory
        let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        do {
            try imageData.write(to: fileURL)
            return CKAsset(fileURL: fileURL)
        } catch {
            // Handle error, failed to write image data to file
            return nil
        }
    }
    
    func createCKAsset(from videoURL: URL) -> CKAsset? {
        let tempDirectoryURL = FileManager.default.temporaryDirectory
        let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension(videoURL.pathExtension)
        
        do {
            try FileManager.default.copyItem(at: videoURL, to: fileURL)
            return CKAsset(fileURL: fileURL)
        } catch {
            // Handle error, failed to copy video file
            return nil
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Exercise Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Difficulty", text: $difficulty)
                    Stepper("Reps: \(reps)", value: $reps)
                    Stepper("Rest: \(rest)", value: $rest)
                }
                
                Section(header: Text("Image")) {
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        Text("Select Image")
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                    }
                }
                
                Section(header: Text("Video")) {
                    Button(action: {
                        isVideoPickerPresented = true
                    }) {
                        Text("Select Video")
                    }
                    .sheet(isPresented: $isVideoPickerPresented) {
                        VideoPicker(selectedVideoURL: $selectedVideoURL)
                    }
                    
                    if let videoURL = selectedVideoURL {
                        Text("Selected Video: \(videoURL.lastPathComponent)")
                            .lineLimit(1)
                    }
                }
                
                Section {
                    Button(action: uploadExercise) {
                        Text("Upload Exercise")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .disabled(name.isEmpty || description.isEmpty || difficulty.isEmpty || selectedImage == nil || selectedVideoURL == nil)
                }
            }
            .navigationTitle("Upload Exercise")
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        imagePickerController.sourceType = .photoLibrary
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct VideoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selectedVideoURL: URL?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.movie"]
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private let parent: VideoPicker
        
        init(_ parent: VideoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let mediaType = info[.mediaType] as? String, mediaType == "public.movie" {
                if let videoURL = info[.mediaURL] as? URL {
                    parent.selectedVideoURL = videoURL
                }
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

