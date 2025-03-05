//
//  EditEarning.swift
//  TennisTracker_Final
//
//  Created by Khanh Nguyen on 3/1/25.
//

	 //
	 //  EditExpense.swift
	 //  TennisTracker_Final
	 //
	 //  Created by Khanh Nguyen on 2/26/25.
	 //

import SwiftData
import SwiftUI

struct editEarning: View {
	 @Environment(\.modelContext) private var context
	 @Environment(\.dismiss) private var dismiss

	 @ObservedObject var earning: Earning

	 var body: some View {
			HStack {
				 Text("Edit Earning")
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
						TextField("Solinco TourBite", text: $earning.title)
				 }
				 Section("Description") {
						TextField("Bought it at Tennis Express", text: $earning.subtitle)
				 }
				 Section("Amount") {
						HStack {
							 Text("$")
									.fontWeight(.semibold)
							 TextField("0.0", value: $earning.amount, formatter: formatter)
									.keyboardType(.decimalPad)
						}
				 }
				 Section("Category") {
						Picker("Category", selection: $earning.category) {
							 ForEach(EarningCategory.allCases, id: \.rawValue) { earning in
									Text(earning.rawValue).tag(earning)
							 }
						}
						.pickerStyle(.menu)
				 }

				 Section("Date") {
						DatePicker("", selection: $earning.date, displayedComponents: [.date])
							 .datePickerStyle(.graphical)
							 .labelsHidden()
				 }
			}
			.navigationTitle("Edit Earning")
			.toolbar {
				 ToolbarItem(placement: .topBarTrailing) {
						Button("Save") {  
							 saveExpense()
						}
						.tint(.green)
						.disabled(isSaveDisabled)
				 }
			}
	 }

			// Renamed from addButtonDisable to isSaveDisabled for clarity
	 var isSaveDisabled: Bool {
			return earning.title.isEmpty || earning.subtitle.isEmpty || earning.amount == 0.0
	 }

			// Simplified save function since we're editing an existing expense
	 func saveExpense() {
				 // The @Bindable var expense is already bound to the model context,
				 // so changes are automatically tracked. We just need to dismiss the view.
			dismiss()
	 }

	 var formatter: NumberFormatter {
			let formatter = NumberFormatter()
			formatter.numberStyle = .decimal
			formatter.maximumFractionDigits = 2
			return formatter
	 }
}
