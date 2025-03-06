import SwiftUI
import SwiftData

struct AnotherTestView: View {
	 @Environment(\.modelContext) var modelContext
	 @Query var expenses: [Expense]

			// Add a method to populate sample data
	 private func addSampleData() {
			if expenses.isEmpty {
				 for expense in sampleExpenses {
						modelContext.insert(expense)
				 }

						// Save the context
				 do {
						try modelContext.save()
				 } catch {
						print("Failed to save sample data: \(error)")
				 }
			}
	 }
	 var body: some View {
			VStack {
				 Text("hello world")
				 List {
						ForEach(expenses, id: \.self) { expense in
							 HStack {
									VStack(alignment: .leading) {
										 Text(expense.title)
												.font(.headline)
										 Text(expense.subtitle)
												.font(.subheadline)
												.foregroundStyle(.gray)
									}
									Spacer()
									VStack(alignment: .trailing) {
										 Text("$\(expense.amount, specifier: "%.2f")")
												.font(.headline)
										 Text(expense.date, style: .date)
												.font(.caption)
												.foregroundStyle(.gray)
									}
							 }
							 .padding(.vertical, 4)
						}
						.onDelete(perform: deleteQuery)
				 }
			}
			.onAppear {
				 addSampleData() // Populate the sample data when the view appears
			}
	 }

	 func deleteQuery(_ indexSet: IndexSet) {
			for index in indexSet {
				 let expense = expenses[index] // Changed from Expense[index] to expenses[index]
				 modelContext.delete(expense)
			}
	 }
}

#Preview {
	 AnotherTestView()
			.modelContainer(for: Expense.self) // Use in-memory storage for previews
}
