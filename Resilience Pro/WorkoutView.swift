//
//  WorkoutView.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//
import SwiftUI


struct WorkoutView: View {
    var workout: WorkoutModel
    var safeArea: EdgeInsets
    var size: CGSize
    @ObservedObject var blocksViewModel: BlocksViewModel

    init(workout: WorkoutModel, safeArea: EdgeInsets, size: CGSize) {
        self.workout = workout
        self.safeArea = safeArea
        self.size = size
        let blockIds = workout.blocks.map { $0.recordID }
        self.blocksViewModel = BlocksViewModel(blockIDs: blockIds)
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                ArtWork()
                VStack{
                        ExercisesView()
                    
                }
            }
            .overlay(alignment: .top) {
                HeaderView()
            }
        }
        .coordinateSpace(name: "SCROLL")
    }
        

    
    @ViewBuilder
     func ArtWork()->some View{
         let height = size.height * 0.45
         GeometryReader{proxy in
             let size = proxy.size
             let minY = proxy.frame(in: .named("SCROLL")).minY
             let progress = minY / (height * (minY > 0 ? 0.4 : 0.8))
             
             Image(uiImage: workout.image.image ?? UIImage())
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
                 .clipped()
                 .overlay(content: {
                     ZStack(alignment: .bottom) {
                         Rectangle()
                             .fill(
                                 .linearGradient(colors: [
                                     .black.opacity(0 - progress),
                                     .black.opacity(0.1 - progress),
                                     .black.opacity(0.3 - progress),
                                     .black.opacity(0.5 - progress),
                                     .black.opacity(0.8 - progress),
                                     .black.opacity(1),
                                 ], startPoint: .top, endPoint: .bottom)
                             )
                         
                         VStack(spacing: 0){
                             Text(workout.difficulty.uppercased())
                                 .font(.caption)
                                 .fontWeight(.bold)
                                 .foregroundColor(.gray)
                                 .padding(.top,15)
                                 .frame(maxWidth: .infinity, alignment: .leading)
                             
                             Text(workout.name)
                                 .font(.system(size: 30))
                                 .fontWeight(.bold)
                                 .frame(maxWidth: .infinity, alignment: .leading)
                             
                             Text(workout.description.uppercased())
                                 .font(.caption)
                                 .fontWeight(.bold)
                                 .foregroundColor(.gray)
                                 .padding(.top,15)
                                 .frame(maxWidth: .infinity, alignment: .leading)
                         }
                         .opacity(1 + (progress > 0 ? -progress : progress))
                         .padding(.bottom, 20)
                         .padding(.leading, 15)
                         .padding(.trailing, 15)
                         // Moving With ScrollView
                         .offset(y: minY < 0 ? minY : 0)
                     }
                 })
                 .offset(y: -minY)
         }
         .frame(height: height + safeArea.top)
     }

    @ViewBuilder
    func ExercisesView() -> some View {
        VStack(spacing: 30) {
            if blocksViewModel.isLoaded == false {
                ProgressView()
            } else {
                ForEach(blocksViewModel.blocks, id: \.self) { block in
                    BlockView(block: block)
                }
            }
        }
        .padding(.trailing, 15)
        .padding(.leading, 15)
        .padding(.bottom, 25)
    }



    @ViewBuilder
    func HeaderView()->some View{
        GeometryReader{proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let height = size.height * 0.45
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            let titleProgress = minY / height
            
            HStack(spacing: 30){
                Spacer(minLength: 20)
            }
            .overlay(content: {
                Text(workout.name)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))

                    .offset(y: -titleProgress > 0.75 ? 0 : 45)
                    .clipped()
                    .animation(.easeInOut(duration: 0.25), value: -titleProgress > 0.75)
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
            .padding(.top,safeArea.top + 35)
            .padding(.bottom, 35)
            .padding(.leading, 15)
            .background(content: {
                Color.black
                    .opacity(-progress > 1 ? 1 : 0)
            })
            .offset(y: -minY)
        }
        .frame(height: 30)
    }
}
