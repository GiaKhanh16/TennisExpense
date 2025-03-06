//
//  EditExpense.swift
//  TennisTracker_Final
//
//  Created by Khanh Nguyen on 2/26/25.
//

import SwiftData
import SwiftUI

struct editExpense: View {
	 @Environment(\.modelContext) private var context
	 @Environment(\.dismiss) private var dismiss
	 let isNewExpense: Bool
	 @Bindable var expense: Expense

	 var body: some View {
			VStack {
				 HStack {
						Text("Edit Expense")
							 .font(.system(size:30))
							 .bold()
						Spacer()
						Button("Save") {  // Changed from empty ToolbarItem to Button
							 saveExpense()
						}
						.tint(.green)
						.disabled(isSaveDisabled)
				 }
				 .padding(EdgeInsets(top: 25, leading: 20, bottom: -5, trailing: 20))
				 List {
						Section("Title") {
							 TextField("Solinco TourBite", text: $expense.title)
						}
						Section("Description") {
							 TextField("Bought it at Tennis Express", text: $expense.subtitle)
						}
						Section("Amount") {
							 HStack {
									Text("$")
										 .fontWeight(.semibold)
									TextField("0.0", value: $expense.amount, formatter: formatter)
										 .keyboardType(.decimalPad)
							 }
						}
						Section("Category") {
							 Picker("Category", selection: $expense.category) {
									ForEach(ExpenseCategory.allCases, id: \.rawValue) { expense in
										 Text(expense.rawValue).tag(expense)
									}
							 }
							 .pickerStyle(.menu)
						}

						Section("Date") {
							 DatePicker("", selection: $expense.date, displayedComponents: .date)
									.datePickerStyle(.graphical)
									.labelsHidden()
									.onTapGesture(count: 99) {
									}
						}
				 }
			}
			.onTapGesture {
				 hideKeyboard()
			}
			.scrollIndicators(.hidden)
	 }

			// Renamed from addButtonDisable to isSaveDisabled for clarity
	 var isSaveDisabled: Bool {
			return expense.title.isEmpty || expense.subtitle.isEmpty || expense.amount == 0.0
	 }

			// Simplified save function since we're editing an existing expense
	 func saveExpense() {
			if isNewExpense {
				 let newExpense = Expense(
						title: expense.title,
						subtitle: expense.subtitle,
						date: expense.date,
						amount: expense.amount,
						category: expense.category
				 )
				 context.insert(newExpense)
				 do {
						try context.save()
				 } catch {
						print("Failed to save expense: \(error)")
				 }
			}
			dismiss()
	 }
	 var formatter: NumberFormatter {
			let formatter = NumberFormatter()
			formatter.numberStyle = .decimal
			formatter.maximumFractionDigits = 2
			return formatter
	 }
}




