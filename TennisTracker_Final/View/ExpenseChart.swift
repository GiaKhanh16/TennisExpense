	 //	 //
	 //	 //  SwiftUIView.swift
	 //	 //  TennisTracker
	 //	 //
	 //	 //  Created by Khanh Nguyen on 2/20/25.
	 //	 //
	 //
	 //import SwiftUI
	 //import Charts
	 //import SwiftData
	 //struct ExpenseTotal: Identifiable {
	 //	 let id = UUID()
	 //	 let category: String
	 //	 let amount: Double
	 //}
	 //struct ExpenseChart: View {
	 //
	 ////	 var totalExpense: Double {
	 ////			sampleExpenses.reduce(0) { $0 + $1.amount }
	 ////	 }
	 ////	 let category: [String] = ["Expenses", "Earnings", "Result"]
	 ////
	 ////	 @State var pickerState: String = "Expenses"
	 //
	 //
	 //	 let expenseTotalsByCategory: [String: Double] = [
	 //			"Traveling & Housing": travelingHousingTotal,
	 //			"Equipment & Gear": equipmentTotal,
	 //			"Coaching & Training": trainingTotal,
	 //			"Other": otherTotal
	 //	 ]
	 //	 let expenseTotalsArray = expenseTotalsByCategory.map { key, value in
	 //			ExpenseTotal(category: key, amount: value)
	 //	 }
	 //	 var body: some View {
	 //			VStack {
	 //
	 //				 Chart(expenseTotalsArray, id: \.id) { element in
	 //						BarMark(
	 //							 x: .value("Category", element.category),
	 //							 y: .value("Amount", element.value)
	 //						)
	 //						.foregroundStyle(by: .value("Name", element.category.rawValue))
	 //						.clipShape(RoundedRectangle(cornerRadius: 8))
	 //						.annotation {
	 //							 Text("\(element.amount, format: .currency(code: "USD"))")
	 //									.font(.footnote)
	 //									.padding(3)
	 //						}
	 //
	 //				 }
	 //				 .chartXAxis(.hidden)
	 //				 .chartYAxis(.hidden)
	 //				 .frame(height: UIScreen.main.bounds.height * 0.3)
	 //				 .padding(.horizontal,20)
	 //
	 //
	 //						//							 HStack {
	 //						//									Text("Total: \(totalExpense, format: .currency(code: "USD"))")
	 //						//										 .foregroundStyle(.secondary)
	 //						//										 .fontWeight(.semibold)
	 //						//									Spacer()
	 //						//							 }
	 //			}
	 //	 }
	 //}
	 //




import SwiftUI
import Charts

struct ExpenseTotal: Identifiable {
	 let id = UUID()
	 let category: String
	 let amount: Double
}

struct ExpenseChartView: View {
	 let dateRange: DateRange
	 var filteredList: [Expense] {
			sampleExpenses.filter {
				 $0.date >= dateRange.startTime && $0.date <= dateRange.endTime
			}
	 }

	 var travelExpense: Double {
			filteredList.filter { $0.category == .travelingHousing }.reduce(0) { $0 + $1.amount }
	 }

	 var equipmentExpense: Double {
			filteredList.filter { $0.category == .equipment }.reduce(0) { $0 + $1.amount }
	 }

	 var coachingExpense: Double {
			filteredList.filter { $0.category == .training }.reduce(0) { $0 + $1.amount }
	 }

	 var tournamentExpense: Double {
			filteredList.filter { $0.category == .tournament }.reduce(0) { $0 + $1.amount }
	 }



	 var totalIncomeData: [String: Double] {
			[
				 "Traveling & Housing": travelExpense,
				 "Equipment & Gear": equipmentExpense,
				 "Coaching & Training": coachingExpense,
				 "Tournament": tournamentExpense
			]
	 }

//	 let expenseTotalsByCategory: [String: Double]

			// Convert dictionary to array when the view is created
			// Convert dictionary to sorted array
	 private var expenseTotalsArray: [ExpenseTotal] {
			totalIncomeData
				 .map { key, value in ExpenseTotal(category: key, amount: value) }
				 .sorted { $0.category < $1.category } // Stable alphabetical order
	 }
	 
	 @State private var animateBars: Bool = false // Track animation state
	 var body: some View {
			Chart(expenseTotalsArray) { element in
				 BarMark(
						x: .value("Category", element.category),
						y: .value("Amount", animateBars ? element.amount : 0) // Animate height
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
			.frame(height: UIScreen.main.bounds.height * 0.3)
			.padding(.horizontal,20)
			.onAppear {
				 withAnimation(.easeInOut) {
						animateBars = true // Trigger animation
				 }
			}
	 }
}
//	 #Preview {
//	 	 ExpenseChart()
//	 }
//	 
