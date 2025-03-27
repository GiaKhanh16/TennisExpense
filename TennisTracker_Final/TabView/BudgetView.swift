import SwiftUI
import SwiftData

extension DateFormatter {
	 static let shortDate: DateFormatter = {
			let formatter = DateFormatter()
			formatter.dateStyle = .medium
			return formatter
	 }()
}


struct BudgetView: View {
	 @State private var dateRange = DateRange()
	 var height = UIScreen.main.bounds.height
	 let score: Int = 990
	 let bounceRate: Double = 2.38
	 @State var popToggle:  Bool = false
	 @State var bugetToggle: Bool = false
	 @AppStorage("budget") private var budget: Double = 2000.00
	 @AppStorage("inputBudget") private var inputBudget: Double = 2000.00
	 @Query var expenses: [Expense]
	 @Query var earnings: [Earning]
	 @Query var serves: [serveModel]

	 var filteredExpenses: [Expense] {
			expenses.filter { expense in
				 expense.date >= dateRange.startTime && expense.date <= dateRange.endTime
			}
	 }
	 var totalExpensesAmount: Double { filteredExpenses.reduce(0) { $0 + $1.amount } }

	 private var progress: CGFloat {
			CGFloat(totalExpensesAmount / budget)
	 }

	 var filteredEarning: [Earning] {
			earnings.filter { item in
				 item.date >= dateRange.startTime && item.date <= dateRange.endTime
			}
	 }
	 var totalEarningAmount: Double { filteredEarning.reduce(0) { $0 + $1.amount } }


	 var filteredServe: [serveModel] {
			serves.filter { expense in
				 expense.date >= dateRange.startTime && expense.date <= dateRange.endTime
			}
			.sorted { $0.date > $1.date }
	 }
	 var monthlyAvg: Double {
			let totalSum = filteredServe.reduce(0) { $0 + $1.total }
			let inServeSum = filteredServe.reduce(0) { $0 + $1.inServe }

			return totalSum > 0 ? Double(inServeSum) / Double(totalSum) * 100 : 0
	 }
	 var tournamentCount: Int {filteredEarning.filter { $0.category == .tourney }.count }

	 var body: some View {

			NavigationStack {
				 ZStack(alignment: .top) {
						VStack(spacing: 0) {
							 Color.gray80.opacity(0.8)
									.frame(height: height * 0.35)
									.ignoresSafeArea(edges: .top)
									.clipShape(.rect(bottomLeadingRadius: 30, bottomTrailingRadius:30))
							 Spacer()
						}
						.ignoresSafeArea(edges: .top)
						VStack {
							 budgetGraph(
									progress: progress,
									color: Color(.systemGray3),
									lineWidth: 20
							 )
							 .frame(width: 300, height: 300)
							 .overlay(
									VStack(spacing: 15) {
										 Text("$\(String(format: "%.2f", totalExpensesAmount))")
												.font(.system(size: 24, weight: .bold, design: .monospaced))
												.foregroundStyle(.white)
										 HStack {
												Text("of $\(String(format: "%.2f", budget)) budget")
													 .font(.system(size: 16, design: .monospaced))
													 .foregroundStyle(Color.gray30)
										 }
									}
										 .offset(y:-55)
							 )
							 .padding(.top,height * 0.14)
							 .padding(.bottom, height * -0.12)

							 VStack(spacing: 6){
									HStack {
										 moneyCom(icon: "plus.square",money: "Total Earning", amount: totalExpensesAmount)
										 moneyCom(icon: "minus.square",money: "Total Earning", amount: totalEarningAmount)
									}
									HStack {
										 ServeCom(content: monthlyAvg)
										 TourCom(content: tournamentCount)
									}

							 }
							 .padding(.horizontal, 10)
							 .padding(.vertical, -12)
						}
				 }
				 .ignoresSafeArea()
				 .toolbar {
						ToolbarItem(placement: .navigationBarTrailing) {
							 Button {
									bugetToggle.toggle()
							 } label: {
									Image(systemName: "slider.horizontal.2.square")
										 .resizable()
										 .frame(width: 20, height: 20)
										 .padding(.horizontal,5)
										 .tint(.gray20)
							 }
							 .popover(isPresented: $bugetToggle,  attachmentAnchor: .point(.bottomTrailing), content: {
									VStack(alignment: .leading){

										 DatePicker(
												"From",
												selection: $dateRange.startTime,
												displayedComponents: .date
										 )

										 DatePicker(
												"To",
												selection: $dateRange.endTime,
												displayedComponents: .date
										 )
										 VStack(alignment: .leading) {
												Text("Set Budget:")


												TextField("Enter your budget", value: $inputBudget, format: .number)
													 .textFieldStyle(.roundedBorder)
													 .frame(maxWidth: 100)
												Button("Update") {
													 budget = inputBudget
													 dateRange = DateRange()

													 bugetToggle.toggle()
												}
										 }
										 .padding(.vertical)
									}
									.preferredColorScheme(.dark)
									.padding(20)
									.presentationCompactAdaptation(.popover)
							 })
						}
				 }
				 .preferredColorScheme(.dark)
				 .navigationTitle("\(dateRange.monthName)")
				 .navigationBarTitleDisplayMode(.inline)


			}

	 }


	 func categoryIcon(for category: EarningCategory) -> String {
			switch category {
				 case .tourney: return "🏨"
				 case .sponsor: return "🎾"
				 case .coaching: return "🏃"
				 case .other: return "📝"
			}
	 }
}

struct Card2: View {
	 let title: String
	 let color: Color
	 let icon: String
	 let progressBar: Bool
	 let goalAmount: Int
	 let currentAmount: Int
	 let textPhrase: Bool


	 var body: some View {
			VStack(alignment: .leading, spacing: 10) {
				 HStack {
						ZStack {
							 Rectangle()
									.cornerRadius(14)
									.frame(width: 35, height: 35)
									.foregroundStyle(.purple.opacity(0.1))
							 Image(systemName: icon)
									.resizable()
									.frame(width: 20, height: 20)
									.foregroundColor(.purple)
						}
						.frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
						Text("Goal: 75%")
							 .frame(width: 80)
							 .font(.callout)
							 .foregroundColor(color)
							 .padding(.horizontal, 5)
				 }

				 Text(title)
						.font(.system(size: 14))
						.fontWeight(.semibold)
						.foregroundColor(.white)
						.padding(.top, 4)

				 if textPhrase {
						Text("\(goalAmount)")
							 .font(.callout)
							 .foregroundColor(color)
				 }
				 else {
						Text("\(currentAmount) out of \(goalAmount)")
							 .font(.callout)
							 .foregroundColor(color)
				 }
									if progressBar {
												GeometryReader { geometry in
													 ZStack(alignment: .leading) {
															Rectangle()
																 .frame(height: 10)
																 .foregroundColor(Color(.systemGray5))
																 .cornerRadius(5)
						
															Rectangle()
																 .frame(width: min(geometry.size.width * CGFloat(currentAmount) / CGFloat(goalAmount), geometry.size.width), height: 10)
																 .foregroundColor(.purple)
																 .cornerRadius(5)
													 }
												}
												.frame(height: 10)
										 }

			}
			.padding()
			.background( Color.gray.opacity(0.16))
			.cornerRadius(15)

	 }
}


struct budgetGraph: View {
	 var progress: CGFloat 
	 var color: Color
	 var lineWidth: CGFloat

	 var body: some View {
			ZStack {
				 Circle()
						.trim(from: 0, to: 0.5)
						.stroke(style: StrokeStyle(
							 lineWidth: lineWidth,
							 lineCap: .round,
							 lineJoin: .round
						))
						.rotationEffect(.degrees(180))
						.foregroundStyle(Color(.systemGray4))

				 Circle()
						.trim(from: 0, to: min(progress * 0.5, 0.5))
						.stroke(style: StrokeStyle(
							 lineWidth: lineWidth,
							 lineCap: .round,
							 lineJoin: .round
						))
						.rotationEffect(.degrees(180))
						.foregroundStyle(
							 Color.secondaryC
						)
						.animation(.easeOut(duration: 0.5), value: progress)
			}
	 }
}

#Preview {
	 BudgetView()
}


struct lessonCom: View {

	 var body: some View {
			VStack(alignment: .leading, spacing: 10) {
				 HStack {
						ZStack {
							 Rectangle()
									.cornerRadius(14)
									.frame(width: 35, height: 35)
									.foregroundStyle(.purple.opacity(0.1))
							 Image(systemName: "person.fill")
									.resizable()
									.frame(width: 20, height: 20)
									.foregroundColor(.purple)
						}
						.frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
				 }

				 Text("Lessons")
						.font(.system(size: 16))
						.fontWeight(.semibold)
						.foregroundColor(.white)
						.padding(.top, 4)
				 Text("5 out of 10")
//				 GeometryReader { geometry in
//						ZStack(alignment: .leading) {
//							 Rectangle()
//									.frame(height: 10)
//									.foregroundColor(Color(.systemGray5))
//									.cornerRadius(5)
//
//							 Rectangle()
//									.frame(width: min(geometry.size.width * CGFloat(5) / CGFloat(10), geometry.size.width), height: 10)
//									.foregroundColor(.purple)
//									.cornerRadius(5)
//						}
//				 }
//				 .frame(height: 10)

			}
			.padding()
			.background(Color.gray.opacity(0.16))
			.cornerRadius(15)
	 }
}

struct practiceCom: View {

	 var body: some View {
			VStack(alignment: .leading, spacing: 10) {
				 HStack {
						ZStack {
							 Rectangle()
									.cornerRadius(14)
									.frame(width: 35, height: 35)
									.foregroundStyle(.purple.opacity(0.1))
							 Image(systemName: "tennisball")
									.resizable()
									.frame(width: 20, height: 20)
									.foregroundColor(.purple)
						}
						.frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)



				 }

				 Text("Practice Matches")
						.font(.system(size: 16))
						.fontWeight(.semibold)
						.foregroundColor(.white)
						.padding(.top, 4)
				 Text("5 out of 10")

			}
			.padding()
			.background(Color.gray.opacity(0.16))
			.cornerRadius(15)
	 }
}

struct moneyCom: View {
	 let icon: String
	 let money: String
	 let amount: Double
	 var body: some View {
			VStack(alignment: .leading, spacing: 10) {
				 HStack {
						ZStack {
//							 Rectangle()
//									.cornerRadius(14)
//									.frame(width: 35, height: 35)
//									.foregroundStyle(.purple.opacity(0.1))
							 Image(systemName: icon)
									.resizable()
									.frame(width: 20, height: 20)
									.foregroundColor(.purple)
						}
						.frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
				 }

				 Text(money)
						.font(.system(size: 16))
						.fontWeight(.semibold)
						.foregroundColor(Color.primary0)
						.padding(.top, 4)
				 Text(amount, format: .currency(code: "USD"))
			}
			.padding()
			.background(Color.gray.opacity(0.16))
			.cornerRadius(15)
	 }
}

struct ServeCom: View {
	 let content: Double
	 var body: some View {
			VStack(alignment: .leading, spacing: 10) {
				 HStack {
						ZStack {
							 Rectangle()
									.cornerRadius(14)
									.frame(width: 35, height: 35)
									.foregroundStyle(.purple.opacity(0.1))
							 Image(systemName: "percent")
									.resizable()
									.frame(width: 20, height: 20)
									.foregroundColor(.purple)
						}
						.frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
				 }

				 Text("Average Serve")
						.font(.system(size: 16))
						.fontWeight(.semibold)
						.foregroundColor(Color.primary0)
						.padding(.top, 4)
				 Text(String(format: "%.0f%%", content))
			}
			.padding()
			.background(Color.gray.opacity(0.16))
			.cornerRadius(15)
	 }
}


struct TourCom: View {
	 let content: Int
	 var body: some View {
			VStack(alignment: .leading, spacing: 10) {
				 HStack {
						ZStack {
							 Rectangle()
									.cornerRadius(14)
									.frame(width: 35, height: 35)
									.foregroundStyle(.purple.opacity(0.1))
							 Image(systemName: "trophy")
									.resizable()
									.frame(width: 20, height: 20)
									.foregroundColor(.purple)
						}
						.frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
				 }

				 Text("Tourneys Played")
						.font(.system(size: 16))
						.fontWeight(.semibold)
						.foregroundColor(Color.primary0)
						.padding(.top, 4)
				 Text("\(content)")
			}
			.padding()
			.background( Color.gray.opacity(0.16))
			.cornerRadius(15)
	 }
}

	 //static var primary: Color {
	 //	 return Color(hex: "5E00F5")
	 //}
	 //static var primary500: Color {
	 //	 return Color(hex: "7722FF")
	 //}
	 //static var primary20: Color {
	 //	 return Color(hex: "924EFF")
	 //}
	 //static var primary10: Color {
	 //	 return Color(hex: "AD7BFF")
	 //}
	 //static var primary5: Color {
	 //	 return Color(hex: "C9A7FF")
	 //}
	 //static var primary0: Color {
	 //	 return Color(hex: "E4D3FF")
	 //}
	 //
	 //static var secondaryC: Color {
	 //	 return Color(hex: "FF7966")
	 //}
	 //
	 //static var secondary50: Color {
	 //	 return Color(hex: "FFA699")
	 //}
	 //
	 //static var secondary0: Color {
	 //	 return Color(hex: "FFD2CC")
	 //}
	 //
	 //static var secondaryG: Color {
	 //	 return Color(hex: "00FAD9")
	 //}
	 //
	 //static var secondaryG50: Color {
	 //	 return Color(hex: "7DFFEE")
	 //	 }
	 //
	 //
	 ///				 if progressBar {
	 //
	 //						GeometryReader { geometry in
	 //							 ZStack(alignment: .leading) {
	 //									Rectangle()
	 //										 .frame(height: 10)
	 //										 .foregroundColor(Color(.systemGray5))
	 //										 .cornerRadius(5)
	 //
	 //									Rectangle()
	 //										 .frame(width: geometry.size.width * (currentAmount / goalAmount), height: 10)
	 //										 .foregroundColor(.purple)
	 //										 .cornerRadius(5)
	 //							 }
	 //						}
	 //						.frame(height: 10)
	 //
	 //				 }
//HStack {
//	 Card2(
//			title: "Current Ranking",
//			color: Color.primary0,
//			icon: "numbers.rectangle",
//			progressBar: false,
//			goalAmount: 59,
//			currentAmount: 5,
//			textPhrase: true
//	 )
//	 Card2(
//			title: "Serve Average",
//			color: Color.primary0,
//			icon: "arrowshape.up.fill",
//			progressBar: false,
//			goalAmount: 15,
//			currentAmount: 1,
//			textPhrase: true
//
//
//	 )
//}
//.padding(.horizontal, 20)
//.padding(.top, -12)
//HStack {
//	 Card2(
//			title: "Practice Matches",
//			color: Color.primary0,
//			icon: "tennis.racket.circle.fill",
//			progressBar: true,
//			goalAmount: 10,
//			currentAmount: 5,
//			textPhrase: false
//	 )
//	 Card2(
//			title: "Tournaments Played",
//			color: Color.primary0,
//			icon: "globe",
//			progressBar: true,
//			goalAmount: 2,
//			currentAmount: 1,
//			textPhrase: false
//
//	 )
//}
//.padding(.horizontal, 20)
//.padding(.top, -12)
//GeometryReader { geometry in
//	 ZStack(alignment: .leading) {
//			Rectangle()
//				 .frame(height: 10)
//				 .foregroundColor(Color(.systemGray5))
//				 .cornerRadius(5)
//
//			Rectangle()
//				 //																 .frame(width: min(geometry.size.width * CGFloat(currentAmount) / CGFloat(goalAmount), geometry.size.width), height: 10)
//				 .foregroundColor(.purple)
//				 .cornerRadius(5)
//	 }
//}
//.frame(height: 10)
