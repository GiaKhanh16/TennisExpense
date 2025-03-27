//
//  serveModel.swift
//  TennisTracker_Final
//
//  Created by Khanh Nguyen on 3/23/25.
//
import SwiftUI
import SwiftData
import Foundation

@Model
class serveModel {
	 var title: String
	 var notes: String
	 var percent: Double
	 var date: Date
	 var inServe: Int
	 var outServe: Int
	 var total: Int

	 init(title: String, notes: String, percent: Double, date: Date, inServe: Int, outServe: Int, total: Int) {
			self.title = title
			self.notes = notes
			self.percent = percent
			self.date = date
			self.inServe = inServe
			self.outServe = outServe
			self.total = total
	 }
}
