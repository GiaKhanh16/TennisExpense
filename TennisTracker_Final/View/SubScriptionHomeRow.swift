////
////  Untitled.swift
////  TennisTracker_Final
////
////  Created by Khanh Nguyen on 2/27/25.
////
//
//import SwiftUI
//
//struct SubScriptionHomeRow: View {
//	 @State var sObj: SubscriptionModel = SubscriptionModel(dict: ["name":"Spotify", "icon":"spotify_logo", "price": "5.99"] )
//	 var body: some View {
//			HStack{
//
//				 Image(sObj.icon)
//						.resizable()
//						.frame(width: 40, height: 40)
//
//				 Text(sObj.name)
//						.font(.customfont(.semibold, fontSize: 14))
//						.foregroundColor(.white)
//
//				 Spacer()
//
//				 Text( "$\(sObj.price)" )
//						.font(.customfont(.semibold, fontSize: 14))
//						.foregroundColor(.white)
//
//
//
//			}
//			.padding(15)
//			.frame(minWidth: 0, maxWidth: .infinity, minHeight: 64, maxHeight: 64)
//
//			.background(Color.gray60.opacity( 0.2  ))
//			.overlay {
//				 RoundedRectangle(cornerRadius:  12)
//						.stroke(  Color.gray70, lineWidth: 1)
//			}
//			.cornerRadius(12)
//	 }
//}
