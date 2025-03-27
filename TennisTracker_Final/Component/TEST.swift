import SwiftUI
import ContributionChart

struct TEST: View {
			// Simulated daily exercise minutes for 30 days
	 let exerciseMinutes: [Double] = [
			20, 30, 45, 10, 100, 60, 25,
			30, 50, 15, 40, 20, 30, 55,
			10, 35, 45, 25, 60, 20, 50,
			15, 30, 40, 55, 20, 10, 100
	 ]
	 let rows = 7 // Represents days of the week
	 let columns = 5 // Approximately 5 weeks

	 var body: some View {


				 ContributionChartView(
						data: exerciseMinutes.map { $0 / 60 }, // Normalize (0-1 range)
						rows: rows,
						columns: columns,
						targetValue: 1.0,
						blockColor: .blue
				 )

	 }
}

struct ContentView_Previews: PreviewProvider {
	 static var previews: some View {
			TEST()
	 }
}
