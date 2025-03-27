//
//  ContentView.swift
//  TennisTracker_Final
//
//  Created by Khanh Nguyen on 2/27/25.
//

import SwiftUI

struct ContentView: View {
	 @AppStorage("isFirstTime") private var isFirstTime: Bool = true
	 @State private var activeTab: Tab = .PerformTab
	 init() {
			UITabBar.appearance().isHidden = true
	 }
	 var body: some View {
			ZStack(alignment: .bottom) {

						TabView(selection: $activeTab) {

							 Performance()
									.tag(Tab.PerformTab)
							 Home()
									.tag(Tab.ExpenseTab)

							 BudgetView()
									.tag(Tab.BudgetTab)

						}
						.toolbar(.hidden, for: .tabBar)
						.preferredColorScheme(.dark)
						.background(Color.clear)

						TabBarView(selectedTab: $activeTab)
						.offset(y:10)
				 
			}
			
			.sheet(isPresented: $isFirstTime) {
				 IntroScreen()
						.interactiveDismissDisabled()
			}
	 }
}

#Preview {
    ContentView()
}
