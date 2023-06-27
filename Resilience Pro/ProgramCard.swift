//
//  ProgramCard.swift
//  Resilience Pro
//
//  Created by Francisco Alderete on 26/05/2023.
//
import SwiftUI

struct ProgramCard: View {
    var program: ProgramModel
    
    var body: some View {
        NavigationLink(destination: GeometryReader { geometry in
            let safeArea = geometry.safeAreaInsets
            let size = geometry.size
            ProgramView(program: program, safeArea: safeArea, size: size)
                .ignoresSafeArea(.container, edges: .top)
        }){
            ZStack(alignment: .bottomLeading) {
                Image(uiImage: program.image.image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                    .cornerRadius(8)
                    .clipped()
                    .overlay(Color.black.opacity(0.4))
                
                Text(program.difficulty.uppercased())
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black)
                    .cornerRadius(4)
                    .offset(x: 10, y: -165)
                
                Text("\(program.week_count) SEMANAS")
                    .font(.system(size: 11))
                    .fontWeight(.bold)
                    .foregroundColor(Color(UIColor.systemGray))
                    .offset(x: 10, y: -32)
                
                Text(program.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
            }
        }
    }
}
