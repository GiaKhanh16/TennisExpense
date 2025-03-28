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

extension View {
	 func hideKeyboard() {
			let resign = #selector(UIResponder.resignFirstResponder)
			UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
	 }
}

struct editEarning: View {
	 @Environment(\.modelContext) private var context
	 @Environment(\.dismiss) private var dismiss
	 let isNewExpense: Bool
	 @Bindable var earning: Earning

	 var body: some View {
			VStack {
				 HStack {
						Text("Edit Earning")
							 .font(.system(size:30))
							 .bold()
						Spacer()
						Button("Save") {
							 saveEarning()
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
							 DatePicker("", selection: $earning.date,in: ...Date.now, displayedComponents: [.date])
									.datePickerStyle(.graphical)
									.labelsHidden()
									.onTapGesture(count: 99) {
									}

						}
				 }
			}
			.ignoresSafeArea(.keyboard)
			.onTapGesture {
				 hideKeyboard()
			}
	 }

	 var isSaveDisabled: Bool {
			return earning.title.isEmpty || earning.subtitle.isEmpty || earning.amount == 0.0
	 }

			// Simplified save function since we're editing an existing expense
	 func saveEarning() {
			if isNewExpense {
				 var newEarning = Earning(
						title: earning.title,
						subtitle: earning.subtitle,
						date: earning.date,
						amount: earning.amount,
						category: earning.category
				 )
				 context.insert(newEarning)
				 dismiss()
			}
			else {
				 dismiss()
			}
			
	 }

	 var formatter: NumberFormatter {
			let formatter = NumberFormatter()
			formatter.numberStyle = .decimal
			formatter.maximumFractionDigits = 2
			return formatter
	 }
}
