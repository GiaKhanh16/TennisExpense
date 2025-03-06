////
////  Migration.swift
////  TennisTracker_Final
////
////  Created by Khanh Nguyen on 3/5/25.
////
//
//import Foundation
//import SwiftData
//import SwiftUI
//
//
//enum TrackerSchemaV1: VersionedSchema {
//	 static var versionIdentifier: Schema.Version = .init(1, 0, 0)
//
//	 static var models: [any PersistentModel.Type] {
//			[Expense.self]
//	 }
//
//	 @Model
//	 class Expense {
//			var title: String
//			var subtitle: String
//			var date: Date
//			var amount: Double
//			var category: ExpenseCategory
//
//			init(title: String, subtitle: String, date: Date, amount: Double, category: ExpenseCategory) {
//				 self.title = title
//				 self.subtitle = subtitle
//				 self.date = date
//				 self.amount = amount
//				 self.category = category
//			}
//	 }
//}
//enum TrackerSchemaV2: VersionedSchema {
//	 static var versionIdentifier: Schema.Version = .init(2, 0, 0)
//
//	 static var models: [any PersistentModel.Type] {
//			[Expense.self, Earning.self]
//	 }
//
//	 @Model
//	 class Expense {
//			var title: String
//			var subtitle: String
//			var date: Date
//			var amount: Double
//			var category: ExpenseCategory
//
//			init(title: String, subtitle: String, date: Date, amount: Double, category: ExpenseCategory) {
//				 self.title = title
//				 self.subtitle = subtitle
//				 self.date = date
//				 self.amount = amount
//				 self.category = category
//			}
//	 }
//
//	 @Model
//	 class Earning {
//			var title: String
//			var subtitle: String
//			var date: Date
//			var amount: Double
//			var category: EarningCategory
//
//			init(title: String, subtitle: String, date: Date, amount: Double, category: EarningCategory) {
//				 self.title = title
//				 self.subtitle = subtitle
//				 self.date = date
//				 self.amount = amount
//				 self.category = category
//			}
//	 }
//}
//enum TrackerMigrationPlan: SchemaMigrationPlan {
//	 static var schemas: [any VersionedSchema.Type] {
//			[TrackerSchemaV1.self, TrackerSchemaV2.self]
//	 }
//
//	 static var stages: [MigrationStage] {
//			[
//				 .lightweight(
//						fromVersion: TrackerSchemaV1.self,
//						toVersion: TrackerSchemaV2.self
//				 )
//			]
//	 }
//}
