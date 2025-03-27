	 // Constants.swift

import SwiftUI

struct Constants {
	 static let dateFormatter: DateFormatter = {
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy-MM-dd"
			return formatter
	 }()

	 static let startDate = dateFormatter.date(from: "2025-03-01")!
	 static let endDate = dateFormatter.date(from: "2025-03-31")!
}

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
	 var formattedDateRange: String {
			let formatter = DateFormatter()
			formatter.dateFormat = "MMMM d" // e.g., "March 1"

			let startString = formatter.string(from: startTime)
			let endString = formatter.string(from: endTime)

			return "\(startString) - \(endString)"
	 }

	 var monthName: String {
			let formatter = DateFormatter()
			formatter.dateFormat = "MMMM"
			return formatter.string(from: startTime)
	 }
}
