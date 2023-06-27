//
//  WorkoutView.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//
import SwiftUI
import CloudKit

struct Block {
    let name: String
    let content: [CKRecord.Reference]
    let series: Int64
}

struct WorkoutView: View {
    var workout: WorkoutModel
    var safeArea: EdgeInsets
    var size: CGSize

    init(workout: WorkoutModel, safeArea: EdgeInsets, size: CGSize) {
        self.workout = workout
        self.safeArea = safeArea
        self.size = size
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
           let blocks: [Block] = [
                       Block(name: "Activación 1", content: workout.act_one, series: workout.series[0]),
                       Block(name: "Activación 2", content: workout.act_two, series: workout.series[1]),
                       Block(name: "Bloque 1", content: workout.block_one, series: workout.series[2]),
                       Block(name: "Bloque 2", content: workout.block_two, series: workout.series[3]),
                       Block(name: "Bloque 3", content: workout.block_three, series: workout.series[4]),
                       Block(name: "Bloque 4", content: workout.block_four, series: workout.series[5])
                   ]
           VStack(spacing: 30) {
               ForEach(blocks, id: \.name) { block in
                   BlockView(blockName: block.name, blockContent: block.content, series: block.series)
               }
           }
           .padding(.trailing, 5)
           .padding(.leading, 5)
           .padding(.bottom, 15)
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
