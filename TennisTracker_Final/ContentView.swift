//
//  ContentView.swift
//  TennisTracker_Final
//
//  Created by Khanh Nguyen on 2/27/25.
//

import SwiftUI

struct ContentView: View {
	 @AppStorage("isFirstTime") private var isFirstTime: Bool = true
	 @State private var activeTab = 0


    var body: some View {
			 TabView(selection: $activeTab) {
					Home()
						 .tag(0)
						 .tabItem {
								Image(systemName: "calendar")
								Text("Home")
						 }
						 .toolbarBackground(.visible, for: .tabBar)
					Coaching()
						 .tag(1)
						 .tabItem {
								Image(systemName: "calendar")
								Text("Tournament")
				 }
			 }
			 .sheet(isPresented: $isFirstTime, content: {
					IntroScreen()
						 .interactiveDismissDisabled()
			 })
			 .preferredColorScheme(.dark)

    }
}

#Preview {
    ContentView()
}
