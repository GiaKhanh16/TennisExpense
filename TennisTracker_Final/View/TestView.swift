
import SwiftUI
import Charts
import Observation





struct wholeView: View {

	 let category: [String] = ["Expenses", "Earnings"]
	 @State var tabSelection: String = "Expenses"
	 @State private var dateRange = DateRange()

	 var body: some View {
			VStack {
				 DatePicker(
						"Start Date",
						selection: $dateRange.startTime,
						displayedComponents: .date
				 )
				 .padding(.horizontal, 30)

				 DatePicker(
						"End Date",
						selection: $dateRange.endTime,
						displayedComponents: .date
				 )
				 .padding(.horizontal, 30)
				 Picker("", selection: $tabSelection) {
						ForEach(category, id: \.self) { item in
							 Text(item)
									.font(.system(size: 20))
						}
				 }
				 if tabSelection == "Expenses" {

						SecondChartView(dateRange: dateRange)
				 } else {
						ChartView(dateRange: dateRange)
				 }

				 if tabSelection == "Expenses" {
						listViewExpense(dateRange: dateRange)
				 } else {
						listViewTest(dateRange: dateRange)
				 }
			}
			.onChange(of: tabSelection) { _, _ in
						// Reset dateRange to default when tab changes
				 dateRange = DateRange()
			}


//			listViewTest(dateRange: dateRange)
//			listViewExpense(dateRange: dateRange)
	 }
	 
}



struct Total: Identifiable {
	 let id = UUID()
	 let category: String
	 let amount: Double
}

struct ChartView: View {
	 let dateRange: DateRange
	 var filteredList: [Earning] {
			sampleEarnings.filter {
				 $0.date >= dateRange.startTime && $0.date <= dateRange.endTime
			}
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

	 private var TotalsArray: [Total] {
			totalIncomeData
				 .map { key, value in Total(category: key, amount: value) }
				 .sorted { $0.category < $1.category }
	 }

	 @State private var animateBars: Bool = false
	 var body: some View {
			Chart(TotalsArray) { element in
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

struct SecondChartView: View {
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


	 private var TotalsArray: [Total] {
			totalIncomeData
				 .map { key, value in Total(category: key, amount: value) }
				 .sorted { $0.category < $1.category }
	 }

	 @State private var animateBars: Bool = false
	 var body: some View {
			Chart(TotalsArray) { element in
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



struct listViewTest: View {
	 let dateRange: DateRange
	 var filteredList: [Earning] {
			sampleEarnings.filter {
				 $0.date >= dateRange.startTime && $0.date <= dateRange.endTime
			}
	 }

	 var body: some View {
			VStack {
				 List{
						ForEach(filteredList){ item in
							 VStack {
									HStack {
										 HStack (spacing:10) {
												VStack(alignment: .leading, spacing: 3) {
													 Text(item.title)
															.font(.headline)
															.fontWeight(.semibold)
													 Text(item.subtitle)
															.font(.subheadline)
															.foregroundStyle(Color(red: 0.4627, green: 0.8392, blue: 1.0))
													 Text(item.date, style: .date)
															.font(.caption)
															.foregroundColor(.gray)
												}
												Spacer()
												Text("$\(item.amount, specifier: "%.2f")")
													 .font(.subheadline)
													 .fontWeight(.semibold)
										 }

									}
							 }
						}
						.listRowBackground(Color.gray60.opacity( 0.2))
				 }
			}
	 }
}


struct listViewExpense: View {
	 let dateRange: DateRange
	 var filteredList: [Expense] {
			sampleExpenses.filter {
				 $0.date >= dateRange.startTime && $0.date <= dateRange.endTime
			}
	 }

	 var body: some View {
			VStack {
				 List{
						ForEach(filteredList){ item in
							 VStack {
									HStack {
										 HStack (spacing:10) {
												VStack(alignment: .leading, spacing: 3) {
													 Text(item.title)
															.font(.headline)
															.fontWeight(.semibold)
													 Text(item.subtitle)
															.font(.subheadline)
															.foregroundStyle(Color(red: 0.4627, green: 0.8392, blue: 1.0))
													 Text(item.date, style: .date)
															.font(.caption)
															.foregroundColor(.gray)
												}
												Spacer()
												Text("$\(item.amount, specifier: "%.2f")")
													 .font(.subheadline)
													 .fontWeight(.semibold)
										 }

									}
							 }
						}
						.listRowBackground(Color.gray60.opacity( 0.2))
				 }
			}
	 }
}

#Preview {
	 wholeView()
}
