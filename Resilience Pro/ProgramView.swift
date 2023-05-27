//
//  ProgramView.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//

import SwiftUI

struct ProgramView: View {
    var program: ProgramModel
    var safeArea: EdgeInsets
    var size: CGSize
    @ObservedObject var weeksViewModel: WeeksViewModel

    init(program: ProgramModel, safeArea: EdgeInsets, size: CGSize) {
        self.program = program
        self.safeArea = safeArea
        self.size = size
        let weekIds = program.weeks.map { $0.recordID }
        self.weeksViewModel = WeeksViewModel(weekIDs: weekIds)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                ArtWork()
                VStack{
                    WeeksView()
                }
                .padding(.top,5)
                .zIndex(0)
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
             let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
             
             Image(uiImage: program.image.image ?? UIImage())
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
                 .clipped()
                 .overlay(Color.black.opacity(0.4))
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
                         VStack(spacing: 2){
                             Text(program.difficulty.uppercased())
                                 .font(.caption)
                                 .fontWeight(.bold)
                                 .foregroundColor(.gray)
                                 .padding(.top,15)
                                 .frame(maxWidth: .infinity, alignment: .leading)
                             
                             Text(program.name)
                                 .font(.system(size: 30))
                                 .fontWeight(.bold)
                                 .frame(maxWidth: .infinity, alignment: .leading)
                             
                             Text(program.description.uppercased())
                                 .font(.caption)
                                 .fontWeight(.bold)
                                 .foregroundColor(.gray)
                                 .padding(.top,15)
                                 .frame(maxWidth: .infinity, alignment: .leading)
                         }
                         .opacity(1 + (progress > 0 ? -progress : progress))
                         .padding(.top, 40)
                         .padding(.bottom, 20)
                         .padding(.leading, 15)
                         .padding(.trailing, 15)
                         .offset(y: minY < 0 ? minY : 0)
                     }
                 })
                 .offset(y: -minY)
         }
         .frame(height: height + safeArea.top)
     }
    
    
    @ViewBuilder
    func WeeksView() -> some View {
        if weeksViewModel.isLoaded == false {
            ProgressView()
        } else {
            VStack(spacing: 33) {
                ForEach(weeksViewModel.weeks, id: \.self) { week in
                    NavigationLink(destination: WeekView(week: week)) {
                        HStack(spacing: 10) {
                            Text(week.name)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 50)
                                .padding(14)
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(.systemGray5))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(14)
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                        .opacity(0.9)
                    }
                }
                .padding(.top, 20)
            }
        }
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
                Text(program.name)
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
