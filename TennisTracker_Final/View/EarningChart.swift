//
//  EarningChart.swift
//  TennisTracker_Final
//
//  Created by Khanh Nguyen on 3/1/25.
//

import SwiftUI
import Charts
import SwiftData

struct EarningTotal: Identifiable {
	 let id = UUID()
	 let category: String
	 let amount: Double
}

struct EarningChart: View {
	 @Query var earnings: [Earning]
	 let dateRange: DateRange

	 var filteredList: [Earning] {
			earnings.filter { earning in
				 earning.date >= dateRange.startTime && earning.date <= dateRange.endTime
			}
	 }

	 init(dateRange: DateRange) {
			self.dateRange = dateRange
			self._earnings = Query(sort: [
				 SortDescriptor(\Earning.date, order: .reverse)
			], animation: .snappy)
	 }

	 var tourneyTotal: Double {
			filteredList.filter { $0.category == .tourney }.reduce(0) { $0 + $1.amount }
	 }

	 var sponsorTotal: Double {
			filteredList.filter { $0.category == .sponsor }.reduce(0) { $0 + $1.amount }
	 }

	 var coachingTotal: Double {
			filteredList.filter { $0.category == .coaching }.reduce(0) { $0 + $1.amount }
	 }

	 var otherTotal: Double {
			filteredList.filter { $0.category == .other }.reduce(0) { $0 + $1.amount }
	 }

	 var totalIncomeData: [String: Double] {
			[
				 "Tournament": tourneyTotal,
				 "Sponsor": sponsorTotal,
				 "Other": otherTotal,
				 "Coaching": coachingTotal
			]
	 }

	 private var earningArray: [EarningTotal] {
			totalIncomeData.map { key, value in
				 EarningTotal(category: key, amount: value)
			}
			.sorted { $0.category < $1.category }
	 }

	 @State private var animateBars: Bool = false

	 var body: some View {
			NavigationStack {
				 if earningArray.isEmpty || earningArray.allSatisfy({ $0.amount == 0 }) {
							 // Empty state view
						VStack(spacing: 10) {
							 Image(systemName: "chart.bar.fill")
									.font(.system(size: 40))
									.foregroundStyle(.blue.opacity(0.5))
							 Text("No Earnings Yet")
									.font(.headline)
									.foregroundStyle(.gray)
							 Text("Add some earnings to see your chart!")
									.font(.subheadline)
									.foregroundStyle(.gray.opacity(0.8))
						}
						.frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.27)
						.padding(.horizontal, 20)
						.opacity(animateBars ? 1 : 0) // Fade in effect
						.onAppear {
							 withAnimation(.easeIn(duration: 0.5)) {
									animateBars = true
							 }
						}
				 } else {
							 // Chart view
						Chart(earningArray) { element in
							 BarMark(
									x: .value("Category", element.category),
									y: .value("Amount", animateBars ? element.amount : 0)
							 )
							 .foregroundStyle(by: .value("Name", element.category))
							 .clipShape(RoundedRectangle(cornerRadius: 8))
							 .annotation(position: .top) {
									Text("\(element.amount, format: .currency(code: "USD"))")
										 .font(.footnote)
										 .padding(3)
							 }
						}
						.chartXAxis(.hidden)
						.chartYAxis(.hidden)
						.frame(maxHeight: UIScreen.main.bounds.height * 0.27)
						.padding(.horizontal, 20)
						.onAppear {
							 withAnimation(.easeInOut) {
									animateBars = true
							 }
						}
				 }
			}
	 }
}



//
//import SwiftUI
//import Charts
//
//struct ExpenseTotal: Identifiable {
//	 let id = UUID()
//	 let category: String
//	 let amount: Double
//}
//
//struct ExpenseChartView: View {
//	 let expenseTotalsByCategory: [String: Double]
//
//			// Convert dictionary to array when the view is created
//	 private var expenseTotalsArray: [ExpenseTotal] {
//			expenseTotalsByCategory.map { key, value in
//				 ExpenseTotal(category: key, amount: value)
//			}
//	 }
//
//	 var body: some View {
//			Chart(expenseTotalsArray) { element in
//				 BarMark(
//						x: .value("Category", element.category),
//						y: .value("Amount", element.amount)
//				 )
//				 .foregroundStyle(by: .value("Name", element.category))
//				 .clipShape(RoundedRectangle(cornerRadius: 8))
//				 .annotation(position: .top) {
//						Text("\(element.amount, format: .currency(code: "USD"))")
//							 .font(.footnote)
//							 .padding(3)
//				 }
//			}
//			.chartXAxis(.hidden)
//			.chartYAxis(.hidden)
//			.frame(height: UIScreen.main.bounds.height * 0.3)
//			.padding(.horizontal,20)
//	 }
//}

//blue : equip
//green: tournament
//yellow: orage
// training: pink
// tournament: gray 
