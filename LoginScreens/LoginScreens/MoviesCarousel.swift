//
//  MoviesCarousel.swift
//  LoginScreens
//
//  Created by Charisma Infotainment on 16/05/24.
//

import SwiftUI
 
struct MoviesCarousel: View {
     
    let categoryName: String
     
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(latestmovie) { num in
                        GeometryReader { proxy in
                            let scale = getScale(proxy: proxy)
                            NavigationLink(
                                destination: MovieDetailsView(movie: num),
                                label: {
                                    VStack(spacing: 8) {
                                        Image(num.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 231)
                                            .clipped()
                                            .cornerRadius(10)
//                                            .shadow(radius: 3)
                                    }
                                })
                             
                                .scaleEffect(.init(width: scale, height: scale))
                                //.animation(.spring(), value: 1)
                                .animation(.easeOut(duration: 1))
                                 
                                .padding(.vertical)
                        } //End Geometry
                        .frame(width: 231, height: 309)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 32)
                    } //End ForEach
                } //End HStack
            }// End ScrollView
        }//End VStack
    }
     
    func getScale(proxy: GeometryProxy) -> CGFloat {
        let midPoint: CGFloat = 125
         
        let viewFrame = proxy.frame(in: CoordinateSpace.global)
         
        var scale: CGFloat = 1.0
        let deltaXAnimationThreshold: CGFloat = 125
         
        let diffFromCenter = abs(midPoint - viewFrame.origin.x - deltaXAnimationThreshold / 2)
        if diffFromCenter < deltaXAnimationThreshold {
            scale = 1 + (deltaXAnimationThreshold - diffFromCenter) / 500
        }
         
        return scale
    }
}
 
 
#Preview {
    MoviesCarousel(categoryName: "Top Movie")
}
 
struct Movie : Identifiable {
    var id : Int
    var title : String
    var imageName : String
}
 
var latestmovie = [Movie(id: 0, title: "The Avengers", imageName: "carousel1"),
             Movie(id: 1, title: "Onward", imageName: "carousel2"),
             Movie(id: 2, title: "Soul", imageName: "carousel3"),
             Movie(id: 3, title: "Cruella", imageName: "carousel1"),
             Movie(id: 4, title: "Jungle Cruise", imageName: "carousel2"),
             Movie(id: 5, title: "The Call of the wild", imageName: "carousel3"),
             Movie(id: 6, title: "Joker", imageName: "carousel1"),
             Movie(id: 7, title: "Mulan", imageName: "carousel2"),
             Movie(id: 8, title: "Mortal Kombat", imageName: "carousel3")]

struct MovieDetailsView: View {
     
    let movie: Movie
     
    var body: some View {
        Image(movie.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .navigationTitle(movie.title)
    }
}
