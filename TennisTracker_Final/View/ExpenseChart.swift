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
				 "Traveling": travelExpense,
				 "Equipments": equipmentExpense,
				 "Trainings": coachingExpense,
				 "Tournaments": tournamentExpense
			]
	 }

	 private var expenseTotalsArray: [ExpenseTotal] {
			totalIncomeData
				 .map { key, value in ExpenseTotal(category: key, amount: value) }
				 .sorted { $0.category < $1.category }
	 }

	 @State private var animateBars: Bool = false

	 var body: some View {
			NavigationStack {
				 if expenseTotalsArray.isEmpty || expenseTotalsArray.allSatisfy({ $0.amount == 0 }) {
						VStack(spacing: 10) {
							 Image(systemName: "chart.bar.fill")
									.font(.system(size: 40))
									.foregroundStyle(.red.opacity(0.5))
							 Text("No Expenses Yet")
									.font(.headline)
									.foregroundStyle(.gray)
							 Text("Add some expenses to see your chart!")
									.font(.subheadline)
									.foregroundStyle(.gray.opacity(0.8))
						}
						.frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.27)
						.padding(.horizontal, 20)
						.opacity(animateBars ? 1 : 0)
						.onAppear {
							 withAnimation(.easeIn(duration: 0.5)) {
									animateBars = true
							 }
						}
				 } else {
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
