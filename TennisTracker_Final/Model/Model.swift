	 //
	 //  Model.swift
	 //  TennisTracker_Final
	 //
	 //  Created by Khanh Nguyen on 2/26/25.
	 //

import SwiftUI
import SwiftData
import Foundation

enum ExpenseCategory: String, Codable, CaseIterable {
	 case travelingHousing = "Traveling & Housing"
	 case equipment = "Equipment & Gear"
	 case training = "Training"
	 case tournament = "Tournament"
}




enum EarningCategory:String, Codable, CaseIterable{
	 case tourney = "Tourney"
	 case sponsor = "Sponsor"
	 case coaching = "Coaching"
	 case other = "Other"

}


@Model
class Expense {
	 var title: String
	 var subtitle: String
	 var date: Date
	 var amount: Double
	 var category: ExpenseCategory

	 init(title: String,
				subtitle: String,
				date: Date,
				amount: Double,
				category: ExpenseCategory) {
			self.title = title
			self.subtitle = subtitle
			self.date = date
			self.amount = amount
			self.category = category
	 }
}

@Model
class Earning {
	 var title: String
	 var subtitle: String
	 var date: Date
	 var amount: Double
	 var category: EarningCategory

	 init(title: String, subtitle: String, date: Date, amount: Double, category: EarningCategory) {
			self.title = title
			self.subtitle = subtitle
			self.date = date
			self.amount = amount
			self.category = category
	 }
}






var sampleEarnings: [Earning] = [
	 Earning(
			title: "Local Tennis Tournament",
			subtitle: "Won 1st place",
			date: Date(timeIntervalSinceNow: -86400 * 0), // Today: Mar 03, 2025
			amount: 500.0,
			category: .tourney
	 ),
	 Earning(
			title: "Nike Sponsorship",
			subtitle: "Monthly sponsorship",
			date: Date(timeIntervalSinceNow: -86400 * 1), // 1 day ago: Mar 02, 2025
			amount: 1500.0,
			category: .sponsor
	 ),
	 Earning(
			title: "Private Coaching",
			subtitle: "5 sessions",
			date: Date(timeIntervalSinceNow: -86400 * 2), // 2 days ago: Mar 01, 2025
			amount: 400.0,
			category: .coaching
	 ),
	 Earning(
			title: "Merchandise Sales",
			subtitle: "Sold tennis gear",
			date: Date(timeIntervalSinceNow: -86400 * 3), // 3 days ago: Feb 28, 2025
			amount: 200.0,
			category: .other
	 ),
	 Earning(
			title: "Regional Championship",
			subtitle: "3rd place prize",
			date: Date(timeIntervalSinceNow: -86400 * 4), // 4 days ago: Feb 27, 2025
			amount: 250.0,
			category: .tourney
	 ),
	 Earning(
			title: "Adidas Campaign",
			subtitle: "Promo shoot",
			date: Date(timeIntervalSinceNow: -86400 * 5), // 5 days ago: Feb 26, 2025
			amount: 800.0,
			category: .sponsor
	 ),
	 Earning(
			title: "Group Lessons",
			subtitle: "Weekend clinic",
			date: Date(timeIntervalSinceNow: -86400 * 6), // 6 days ago: Feb 25, 2025
			amount: 600.0,
			category: .coaching
	 ),
	 Earning(
			title: "Online Store Sales",
			subtitle: "Custom rackets",
			date: Date(timeIntervalSinceNow: -86400 * 7), // 7 days ago: Feb 24, 2025
			amount: 350.0,
			category: .other
	 ),
	 Earning(
			title: "State Open",
			subtitle: "Quarterfinals bonus",
			date: Date(timeIntervalSinceNow: -86400 * 8), // 8 days ago: Feb 23, 2025
			amount: 700.0,
			category: .tourney
	 ),
	 Earning(
			title: "Wilson Endorsement",
			subtitle: "Gear sponsorship",
			date: Date(timeIntervalSinceNow: -86400 * 9), // 9 days ago: Feb 22, 2025
			amount: 1200.0,
			category: .sponsor
	 ),
	 Earning(
			title: "Junior Training",
			subtitle: "10 sessions",
			date: Date(timeIntervalSinceNow: -86400 * 10), // 10 days ago: Feb 21, 2025
			amount: 500.0,
			category: .coaching
	 ),
	 Earning(
			title: "Charity Event Sales",
			subtitle: "Signed memorabilia",
			date: Date(timeIntervalSinceNow: -86400 * 11), // 11 days ago: Feb 20, 2025
			amount: 300.0,
			category: .other
	 ),
	 Earning(
			title: "National Qualifier",
			subtitle: "Semifinals prize",
			date: Date(timeIntervalSinceNow: -86400 * 12), // 12 days ago: Feb 19, 2025
			amount: 900.0,
			category: .tourney
	 ),
	 Earning(
			title: "Under Armour Deal",
			subtitle: "Seasonal bonus",
			date: Date(timeIntervalSinceNow: -86400 * 13), // 13 days ago: Feb 18, 2025
			amount: 1000.0,
			category: .sponsor
	 ),
	 Earning(
			title: "Corporate Coaching",
			subtitle: "Team building event",
			date: Date(timeIntervalSinceNow: -86400 * 14), // 14 days ago: Feb 17, 2025
			amount: 750.0,
			category: .coaching
	 )
]

var tourneyTotal = sampleEarnings.filter { $0.category == .tourney}.reduce(0) { $0 + $1.amount }
var sponsorTotal = sampleEarnings.filter { $0.category == .sponsor}.reduce(0) { $0 + $1.amount }
var coachingTotal = sampleEarnings.filter { $0.category == .coaching}.reduce(0) { $0 + $1.amount }
var otherTotal = sampleEarnings.filter { $0.category == .other}.reduce(0) { $0 + $1.amount }

var sampleExpenses: [Expense] = [
	 Expense(title: "Hotel Stay", subtitle: "Tournament in Florida", date: Date(timeIntervalSinceNow: -86400 * 7), amount: 249.99, category: .travelingHousing), // March 03 - 7 days = Feb 24, 2025
	 Expense(title: "New Racket", subtitle: "Wilson Pro Staff", date: Date(timeIntervalSinceNow: -86400 * 6), amount: 2000.95, category: .equipment),       // Feb 25, 2025
	 Expense(title: "Private Lesson", subtitle: "Serve technique", date: Date(timeIntervalSinceNow: -86400 * 5), amount: 75.00, category: .training),     // Feb 26, 2025
	 Expense(title: "Tournament Fee", subtitle: "Entry cost", date: Date(timeIntervalSinceNow: -86400 * 4), amount: 45.00, category: .tournament),        // Feb 27, 2025
	 Expense(title: "Tournament Fee", subtitle: "Entry cost", date: Date(timeIntervalSinceNow: -86400 * 3), amount: 45.00, category: .tournament),        // Feb 28, 2025
	 Expense(title: "Tournament Fee", subtitle: "Entry cost", date: Date(timeIntervalSinceNow: -86400 * 2), amount: 45.00, category: .tournament),        // March 01, 2025
	 Expense(title: "Tournament Fee", subtitle: "Entry cost", date: Date(timeIntervalSinceNow: -86400 * 1), amount: 45.00, category: .tournament)         // March 02, 2025
]
var travelingHousingTotal = sampleExpenses
	 .filter { $0.category == .travelingHousing }
	 .reduce(0) { $0 + $1.amount }

var equipmentTotal = sampleExpenses
	 .filter { $0.category == .equipment }
	 .reduce(0) { $0 + $1.amount }

var trainingTotal = sampleExpenses
	 .filter { $0.category == .training }
	 .reduce(0) { $0 + $1.amount }

var tournamentTotal = sampleExpenses
	 .filter { $0.category == .tournament }
	 .reduce(0) { $0 + $1.amount }
