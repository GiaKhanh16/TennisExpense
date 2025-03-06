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

@Observable
class DateRange {
	 var startTime: Date
	 var endTime: Date

	 init() {
			let currentDate = Date()
			let calendar = Calendar.current

				 // Get the start of the current month
			guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else {
				 self.startTime = currentDate
				 self.endTime = currentDate
				 return
			}

				 // Get the last day of the current month
			guard let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) else {
				 self.startTime = currentDate
				 self.endTime = currentDate
				 return
			}

			self.startTime = startDate
			self.endTime = endDate
	 }
}


struct Home: View {
	 @State var tabSelection: String = "Expenses"
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
						Spacer().frame(height: 35)
						Picker("", selection: $tabSelection) {
							 ForEach(category, id: \.self) { item in
									Text(item)
										 .font(.system(size: 20))
							 }
						}

						.pickerStyle(.segmented)
						.background(Color.black)
						.padding(.horizontal, 55)
						.offset(y: -10)

						if tabSelection == "Expenses" {
							 ListView(dateRange: dateRange, onItemTap: { expense in
									selectedExpense = expense
							 })
						} else {
							 EarningView(dateRange: dateRange, onItemTap: { earning in
//									showingEditSheet = true
									selectedEarning = earning
							 })
						}
				 }
				 .onChange(of: tabSelection) { _, _ in
						dateRange = DateRange()
				 }
				 .ignoresSafeArea(.all)
				 .navigationTitle(
						tabSelection == "Expenses" ? "Expenses" : "Earnings"
				 )

				 .navigationBarTitleDisplayMode(.inline)
				 .sheet(item: $selectedExpense) { expense in
						editExpense(isNewExpense: false, expense: expense)
				 }
				 .sheet(item: $selectedEarning) { earning in
						editEarning(isNewExpense: false, earning: earning)
				 }
				 .sheet(isPresented: $showingNewSheet) {
						if tabSelection == "Expenses" {
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
										 .frame(width: 25, height: 30)
										 .padding(.horizontal,10)
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
							 .contentShape(Rectangle())
							 .onTapGesture {
									onItemTap(item) // Trigger callback when tapped
							 }
						}
						.onDelete(perform: onDeletion)
						.listRowBackground(Color.gray60.opacity( 0.2))
				 }
				 .scrollContentBackground(.hidden)
				 .contentMargins(.top, 0)
				 .scrollIndicators(.hidden)
				 .padding(.bottom, 65)
			}
			.frame(maxWidth: .infinity)
	 }



	 func onDeletion(_ offSet: IndexSet) {
			for index in offSet {
				 let item = filteredExpenses[index]
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
							 .contentShape(Rectangle())
							 .onTapGesture {
									onItemTap(item) // Trigger callback when tapped
							 }
						}
						.onDelete(perform: onDeletion)
						.listRowBackground(Color.gray60.opacity( 0.2))
				 }
				 .scrollContentBackground(.hidden)
				 .contentMargins(.top, 0)
				 .scrollIndicators(.hidden)
				 .padding(.bottom, 65)
			}

			.frame(maxWidth: .infinity)
	 }



	 func onDeletion(_ offSet: IndexSet) {
			for index in offSet {
				 let item = filteredEarnings[index]
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
//#Preview {
//	 Home()
//}

