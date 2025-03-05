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
