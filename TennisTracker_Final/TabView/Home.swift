	 //
	 //  Home.swift
	 //  TennisTracker_Final
	 //
	 //  Created by Khanh Nguyen on 2/27/25.
	 //


import SwiftUI
import Charts
import SwiftData
import Observation



struct CustomPicker: View {
	 @Binding var isExpense: Bool
	 let dateRange: DateRange
	 @Query var expense: [Expense]
	 @Query var earning: [Earning]



	 var filteredExpenses: [Expense] {
			expense.filter { expense in
				 expense.date >= dateRange.startTime && expense.date <= dateRange.endTime
			}
	 }
	 var expenseTotal: Double {
			filteredExpenses.reduce(0) { $0 + $1.amount }
	 }


	 var filteredEarnings: [Earning] {
			earning.filter { earning in
				 earning.date >= dateRange.startTime && earning.date <= dateRange.endTime
			}
	 }

	 var earningTotal: Double {
			filteredEarnings.reduce(0) { $0 + $1.amount }
	 }


	 var body: some View {
			HStack() {
				 Card(
						title: "Total Earnings",
						money: earningTotal,
						color: .purple,
						icon: "chart.bar",
						isSelected: !isExpense,
						onTap: {
							 isExpense = false
						}
				 )
				 Card(
						title: "Total Expenses",
						money: expenseTotal,
						color: .purple,
						icon: "chart.bar",
						isSelected: isExpense,
						onTap: {
							 isExpense = true
						}
				 )
			}
	 }
}


struct Card: View {
	 let title: String
	 let money: Double
	 let color: Color
	 let icon: String
	 let isSelected: Bool 
	 let onTap: () -> Void

	 var body: some View {
			VStack(alignment: .leading, spacing: 10) {
				 ZStack {
						Rectangle()
							 .cornerRadius(14)
							 .frame(width: 43, height: 40)
							 .foregroundStyle(.purple.opacity(0.1))
						Image(systemName: icon)
							 .resizable()
							 .frame(width: 25, height: 20)
							 .foregroundColor(.purple)
				 }
				 .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)

				 Text(title)
						.font(.system(size: 17))
						.fontWeight(.semibold)
						.foregroundColor(.white)
						.padding(.top, 4)

				 Text(money, format: .currency(code: "USD"))
						.font(.callout)
						.foregroundColor(color)
			}
			.padding()
			.background(isSelected ? Color.purple.opacity(0.3) : Color.gray.opacity(0.16)) // Adjusted Color.primary10
			.cornerRadius(15)
			.onTapGesture {
				 onTap()
			}
	 }
}

struct Home: View {
	 @State var isExpense: Bool = false
	 @State private var showingNewSheet = false
	 @State var showPopo: Bool = false
	 @State private var path = [Expense]()
	 @Environment(\.modelContext) var modelContext
	 @State private var dateRange = DateRange()
	 @Query var expenses: [Expense]
	 @State private var selectedExpense: Expense?
	 @State private var selectedEarning: Earning?

	 var height = UIScreen.main.bounds.height
	 let category: [String] = ["Expenses", "Earnings"]



	 var body: some View {
			NavigationStack(path: $path) {

				 VStack {
						VStack(spacing: 30) {
							 Spacer().frame(height: 70)
							 if isExpense {
									ExpenseChartView(dateRange: dateRange)
							 }
							 else {
									EarningChart(dateRange: dateRange)
							 }
						}
						.frame(height: height * 0.41)
						.background{
							 Color.gray80.opacity(0.8)
									.clipShape(.rect(bottomLeadingRadius: 30, bottomTrailingRadius:30))
						}

						Spacer()
						.frame(height: 35)

						HStack {
							 CustomPicker(isExpense: $isExpense, dateRange: dateRange)
						}
						.padding(.horizontal, 20)
						.offset(y:-18)
						.background(Color.black)
						.offset(y: -10)

						if isExpense {
							 ListView(dateRange: dateRange, onItemTap: { expense in
									selectedExpense = expense
							 })
							 .offset(y:-25)
						}
						else {
							 EarningView(dateRange: dateRange, onItemTap: { earning in
									selectedEarning = earning
							 })
							 .offset(y:-25)
						}

				 }
				 .onChange(of: isExpense) { _, _ in
						dateRange = DateRange()
				 }
				 .ignoresSafeArea(.all)
				 .navigationTitle(
						isExpense  ? "Expenses" : "Earnings"
				 )

				 .navigationBarTitleDisplayMode(.inline)
				 .sheet(item: $selectedExpense) { expense in
						editExpense(isNewExpense: false, expense: expense)
				 }
				 .sheet(item: $selectedEarning) { earning in
						editEarning(isNewExpense: false, earning: earning)
				 }
				 .sheet(isPresented: $showingNewSheet) {
						if isExpense {
							 editExpense(isNewExpense: true, expense: Expense(
									title: "",
									subtitle: "",
									date: .now,
									amount: 0,
									category: .equipment
							 ))
						} else {
							 editEarning(isNewExpense: true, earning: Earning(
									title: "",
									subtitle: "",
									date: .now,
									amount: 0,
									category: .sponsor
							 ))
						}
				 }
				 .toolbar {
						ToolbarItem(placement: .navigationBarLeading) {
							 Button {
									showingNewSheet.toggle()
							 } label: {
									Image(systemName: "plus.rectangle.portrait.fill")
										 .resizable()
										 .frame(width: 22, height: 28)
										 .padding(.horizontal,20)
							 }
						}

						ToolbarItem(placement: .navigationBarTrailing) {
							 Button {
									showPopo.toggle()
							 } label: {
									Image(systemName: "calendar")
										 .resizable()
										 .frame(width: 25, height: 25)
										 .padding(.horizontal,5)
										 .tint(.gray20)
							 }
							 .popover(isPresented: $showPopo, content: {
									VStack {

										 DatePicker(
												"From",
												selection: $dateRange.startTime,
												displayedComponents: .date
										 )

										 DatePicker(
												"To",
												selection: $dateRange.endTime,
												displayedComponents: .date
										 )
										 Button(action: {
												dateRange = DateRange()
										 }) {
												Text("Reset")
													 .font(.system(size: 18, weight: .semibold))
													 .foregroundColor(.blue)
													 .bold()
										 }
										 .frame(maxWidth: .infinity, alignment: .leading)

									}
									.padding(20)
									.preferredColorScheme(.dark)
									.presentationCompactAdaptation(.popover)
							 })
						}
				 }
			}
	 }
}


struct ListView: View {
	 @Environment(\.modelContext) var modelContext
	 @Query var expenses: [Expense]
	 let dateRange: DateRange
	 let onItemTap: (Expense) -> Void

	 var filteredExpenses: [Expense] {
			expenses.filter { expense in
				 expense.date >= dateRange.startTime && expense.date <= dateRange.endTime
			}
	 }

	 init(dateRange: DateRange, onItemTap: @escaping (Expense) -> Void) {
			self.dateRange = dateRange
			self.onItemTap = onItemTap

			self._expenses = Query(sort: [
				 SortDescriptor(\Expense.date, order: .reverse)
			], animation: .snappy)
	 }
	 @State private var reachedBottom = false
	 var body: some View {
			VStack {
				 List{
						ForEach(filteredExpenses){ item in
							 VStack {
									HStack {
										 HStack (spacing:10) {
												Text(categoryIcon(for: item.category))
													 .font(.system(size: 35))
												VStack(alignment: .leading, spacing: 3) {
													 Text(item.title)
															.font(.system(size: 15))
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
							 .contentShape(Rectangle())
							 .onTapGesture {
									onItemTap(item)
							 }
						}
						.onDelete(perform: onDeletion)
						.listRowBackground(Color.gray60.opacity( 0.2))
				 }
				 .overlay {

						if filteredExpenses.isEmpty {
							 ContentUnavailableView(label: {
									Label("No Expense Added", systemImage: "list.bullet.rectangle.portrait")
							 },
																			description: {
									Text("Start adding expenses above")
							 })
							 .offset(y: -30)
						}
				 }
				 .scrollContentBackground(.hidden)
				 .contentMargins(.top, 0)
				 .scrollIndicators(.hidden)
			}
			.frame(maxWidth: .infinity)
	 }



	 func onDeletion(_ offSet: IndexSet) {
			for index in offSet {
				 let item = expenses[index]
				 modelContext.delete(item)
			}
			try?	modelContext.save()
	 }

	 func categoryIcon(for category: ExpenseCategory) -> String {
			switch category {
				 case .travelingHousing: return "🏨"
				 case .equipment: return "🎾"
				 case .training: return "🏃"
				 case .tournament: return "📝"
			}
	 }
}



struct EarningView: View {
	 @Environment(\.modelContext) var modelContext
	 @Query var earnings: [Earning]
	 let dateRange: DateRange
	 let onItemTap: (Earning) -> Void

	 var filteredEarnings: [Earning] {
			earnings.filter { earning in
				 earning.date >= dateRange.startTime && earning.date <= dateRange.endTime
			}
	 }

	 init(dateRange: DateRange, onItemTap: @escaping (Earning) -> Void) {
			self.dateRange = dateRange
			self.onItemTap = onItemTap

			self._earnings = Query(sort: [
				 SortDescriptor(\Earning.date, order: .reverse)
			], animation: .snappy)
	 }
	 var body: some View {
			VStack {
				 List{
						ForEach(filteredEarnings){ item in
							 VStack {
									HStack {
										 HStack (spacing:10) {
												Text(categoryIcon(for: item.category))
													 .font(.system(size: 35))
												VStack(alignment: .leading, spacing: 3) {
													 Text(item.title)
															.font(.system(size: 15))
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
							 .contentShape(Rectangle())
							 .onTapGesture {
									onItemTap(item) 
							 }
						}
						.onDelete(perform: onDeletion)
						.listRowBackground(Color.gray60.opacity( 0.2))
				 }
				 .scrollContentBackground(.hidden)
				 .contentMargins(.top, 0)
				 .scrollIndicators(.hidden)
				 .overlay {
						if filteredEarnings.isEmpty {
							 ContentUnavailableView(label: {
									Label("No Earning Added", systemImage: "list.bullet.rectangle.portrait")
							 },
																			description: {
									Text("Start adding earnings above")
							 })
							 .offset(y: -30)
						}
				 }
			}

			.frame(maxWidth: .infinity)
	 }



	 func onDeletion(_ offSet: IndexSet) {
			for index in offSet {
				 let item = earnings[index]
				 modelContext.delete(item)
			}
			try? modelContext.save()
	 }

	 func categoryIcon(for category: EarningCategory) -> String {
			switch category {
				 case .tourney: return "🏨"
				 case .sponsor: return "🎾"
				 case .coaching: return "🏃"
				 case .other: return "📝"
			}
	 }
}


struct HeaderView: View {
	 @State private var dateRange = DateRange()
	 let totalIncomeData = [
			"Traveling & Housing": travelingHousingTotal,
			"Equipment & Gear": equipmentTotal,
			"Coaching & Training": trainingTotal,
			"Tournament": tournamentTotal
	 ]
	 let totalEarningData = [
			"Tournament": tourneyTotal,
			"Sponsor": sponsorTotal,
			"Other": otherTotal,
			"Coaching": coachingTotal
	 ]
	 var height = UIScreen.main.bounds.height
	 @Binding var tabSelection: String


	 var body: some View {
			VStack(spacing: 30) {
				 Spacer().frame(height: 70)
				 if tabSelection == "Expenses" {
						ExpenseChartView(dateRange: dateRange)
				 }
				 else {
						EarningChart(dateRange: dateRange)
				 }
			}

			.frame(height: height * 0.45)
			.background{
				 Color(hex: "353542")
						.clipShape(.rect(bottomLeadingRadius: 30, bottomTrailingRadius:30))
			}
	 }
}


//
#Preview {
	 Home()
}

