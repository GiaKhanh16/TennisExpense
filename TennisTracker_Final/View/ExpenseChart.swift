
import SwiftUI
import Charts
import SwiftData

struct ExpenseTotal: Identifiable {
	 let id = UUID()
	 let category: String
	 let amount: Double
}


struct ExpenseChartView: View {

	 @Environment(\.modelContext) var modelContext
	 @Query var expenses: [Expense]
	 let dateRange: DateRange



	 var filteredExpenses: [Expense] {
			expenses.filter { expense in
				 expense.date >= dateRange.startTime && expense.date <= dateRange.endTime
			}
	 }

	 init(dateRange: DateRange) {
			self.dateRange = dateRange

			self._expenses = Query(sort: [
				 SortDescriptor(\Expense.date, order: .reverse) 
			], animation: .snappy)
	 }




//
//	 var filteredList: [Expense] {
//			expenses.filter {
//				 $0.date >= dateRange.startTime && $0.date <= dateRange.endTime
//			}
//	 }

	 var travelExpense: Double {
			filteredExpenses.filter { $0.category == .travelingHousing }.reduce(0) { $0 + $1.amount }
	 }

	 var equipmentExpense: Double {
			filteredExpenses.filter { $0.category == .equipment }.reduce(0) { $0 + $1.amount }
	 }

	 var coachingExpense: Double {
			filteredExpenses.filter { $0.category == .training }.reduce(0) { $0 + $1.amount }
	 }

	 var tournamentExpense: Double {
			filteredExpenses.filter { $0.category == .tournament }.reduce(0) { $0 + $1.amount }
	 }



	 var totalIncomeData: [String: Double] {
			[
				 "Traveling & Housing": travelExpense,
				 "Equipment & Gear": equipmentExpense,
				 "Coaching & Training": coachingExpense,
				 "Tournament": tournamentExpense
			]
	 }

	 private var expenseTotalsArray: [ExpenseTotal] {
			totalIncomeData
				 .map { key, value in ExpenseTotal(category: key, amount: value) }
				 .sorted { $0.category < $1.category }
	 }
	 
	 @State private var animateBars: Bool = false
	 var body: some View {
			Chart(expenseTotalsArray) { element in
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
			.frame(height: UIScreen.main.bounds.height * 0.3)
			.padding(.horizontal,20)
			.onAppear {
				 withAnimation(.easeInOut) {
						animateBars = true
				 }
			}
	 }
}

