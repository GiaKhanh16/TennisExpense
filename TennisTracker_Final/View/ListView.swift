////
////  ListView.swift
////  TennisTracker_Final
////
////  Created by Khanh Nguyen on 2/27/25.
////
//
//import SwiftUI
//
//struct ListView: View {
//    var body: some View {
//			 List {
//					ForEach(sampleExpenses, id: \.self) { expense in
//						 NavigationLink(value: expense) {
//								HStack {
//									 Text(categoryIcon(for: expense.category))
//											.foregroundColor(.gray)
//											.font(.system(size: 45))
//									 VStack(alignment: .leading) {
//											Text(expense.title)
//												 .font(.headline)
//
//											Text(expense.subtitle)
//												 .font(.subheadline)
//												 .foregroundColor(Color(red: 0.4627, green: 0.8392, blue: 1.0))
//
//											HStack(alignment: .center, spacing: 12) {
//												 Text("$\(expense.amount, specifier: "%.2f")")
//														.font(.body)
//
//												 Spacer()
//
//												 Text(expense.date, style: .date)
//														.font(.caption)
//														.foregroundColor(.gray)
//											}
//									 }
//								}
//						 }
//					}
//					.onDelete(perform: onDelete)
//			 }
//			 .navigationTitle("Expenses")
//			 .navigationDestination(for:Expense.self) { expense in
//					editExpense(expense: expense)
//			 }
//			 .toolbar {
//					Button("", systemImage: "plus.rectangle.portrait.fill") {
//						 let expense = Expense(
//							 title: "",
//							 subtitle: "",
//							 date: .now,
//							 amount: 0.0,
//							 category: .equipment
//						 )
//						 ModelContext.insert(expense)
//						 path = [expense]
//					}
//			 }
//    }
//}
//
////#Preview {
////    ListView()
////}
