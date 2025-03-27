//
//  IntroView.swift
//  TennisTracker_Final
//
//  Created by Khanh Nguyen on 3/3/25.
//


import SwiftUI

struct IntroScreen: View {
	 @AppStorage("isFirstTime") private var isFirstTime: Bool = true
	 var body: some View {

			Text("Features In TennisNumbers :")
				 .font(.largeTitle.bold())
				 .multilineTextAlignment(.leading)
				 .padding(.leading, -10)
				 .padding(.top, 40)
				 .padding(.bottom, 30)


			VStack(alignment: .leading, spacing: 25, content: {
				 PointView(symbol: "dollarsign", title: "Expenses and Earning", subTitle: "Keep track of your tennis expenses and earnings")
				 PointView(symbol: "percent", title: "Serve Performance", subTitle: "Keep track of the most important stats in winning tennis matches")
				 PointView(symbol: "figure.tennis", title: "Tournaments", subTitle: "Keep track of your potential earnings")
				 PointView(symbol: "chart.bar.fill", title: "Visual Charts", subTitle: "View your transactions and earnings in a fun way")
			})
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.horizontal, 25)
			Spacer(minLength: 25)
			Button(action: {
				 isFirstTime = false
			}, label: {
				 Text("Continue")
						.fontWeight(.bold)
						.foregroundStyle(.white)
						.frame(maxWidth: .infinity)
						.padding(.vertical, 14)
						.background(.blue, in: .rect(cornerRadius:12))
						.contentShape(.rect)
			})
			.padding(25)
			.padding(.bottom,50)
	 }


}

@ViewBuilder
func PointView(symbol: String, title: String, subTitle: String) -> some View {

	 HStack(spacing:15) {
			Image(systemName: symbol)
				 .font(.largeTitle)
				 .frame(width:45)
				 .foregroundStyle(.blue.gradient)
			VStack(alignment: .leading, spacing: 6, content: {
				 Text(title)
						.font(.title3)
						.fontWeight(.semibold)
				 Text(subTitle)
						.foregroundStyle(.gray)
			})
	 }
}

#Preview {
	 IntroScreen()
}
