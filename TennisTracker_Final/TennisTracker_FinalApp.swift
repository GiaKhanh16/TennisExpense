//
//  TennisTracker_FinalApp.swift
//  TennisTracker_Final
//
//  Created by Khanh Nguyen on 2/26/25.
//

import SwiftUI
import SwiftData

@main
struct TennisTracker_FinalApp: App {
	
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
				.modelContainer(for: Expense.self)
		}

}
