import SwiftUI
import SwiftData

@main
struct TennisTracker_FinalApp: App {

	 var body: some Scene {
			WindowGroup {
				 ContentView()

			}
			.modelContainer(for: [Expense.self, Earning.self])
	 }
}
