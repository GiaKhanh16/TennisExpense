import SwiftUI
import SwiftData
import Charts




struct Performance: View {
	 @State private var path = [serveModel]()
	 @State private var dateBtn: Bool = false
	 @State private var modalToggle: Bool = false
	 @State private var dateRange = DateRange()
	 private var height = UIScreen.main.bounds.height
	 @Query var serves: [serveModel]
	 @State var selectedItem: serveModel?
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

	 var body: some View {
			NavigationStack {
				 VStack(spacing: 0){
						ZStack(alignment: .top) {
							 Color.gray80.opacity(0.8)
									.frame(height: height * 0.4)
									.ignoresSafeArea(edges: .top)
									.clipShape(RoundedRectangle(cornerRadius: 30))
							 lineChart(dateRange: dateRange)
						}
							 HStack {
									VStack(alignment: .leading, spacing: 10) {
										 Button {
												dateBtn.toggle()
										 } label: {

												ZStack {
													 Rectangle()
															.frame(width: 35,height: 35)
															.cornerRadius(10)
															.foregroundStyle(Color.blue.opacity(0.1))
													 Image(systemName: "calendar")
															.resizable()
															.frame(width: 20, height: 20)
															.foregroundColor(.blue)
												}
												.frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)


										 }
										 .popover(isPresented: $dateBtn, content: {
												VStack {

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
													 Button(action: {
															dateRange = DateRange()
													 }) {
															Text("Reset")
																 .font(.system(size: 18, weight: .semibold))
																 .foregroundColor(.blue)
																 .bold()
													 }
													 .frame(maxWidth: .infinity, alignment: .leading)

												}
												.padding(20)
												.preferredColorScheme(.dark)
												.presentationCompactAdaptation(.popover)
										 })

										 Text("Date Range")
												.font(.system(size: 16))
												.fontWeight(.semibold)
												.foregroundColor(.white)
												.padding(.top, 4)

										 Text(dateRange.formattedDateRange)
													 .font(.system(size: 15))
													 .font(.callout)
													 .foregroundColor(Color.primary0)
									}
									.padding()
									.background( Color.gray.opacity(0.16))
									.cornerRadius(15)


									VStack(alignment: .leading, spacing: 10) {
										 ZStack {
												Rectangle()
													 .frame(width: 35,height: 35)
													 .cornerRadius(10)
													 .foregroundStyle(Color.blue.opacity(0.1))
												Image(systemName: "figure.tennis")
													 .resizable()
													 .frame(width: 20, height: 20)
													 .foregroundColor(.blue)
										 }
										 .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)

										 Text("Serve Average")
												.font(.system(size: 16))
												.fontWeight(.semibold)
												.foregroundColor(.white)
												.padding(.top, 4)

										 Text(String(format: "%.0f%%", monthlyAvg))
												.font(.callout)
												.foregroundColor(Color.primary0)
									}
									.padding()
									.background( Color.gray.opacity(0.16))
									.cornerRadius(15)

							 }
							 .padding(.horizontal, 20)
							 .padding(.top, height * -0.09)
						ServeDataList(dateRange: dateRange, onItemTap: {
							 item in
							 selectedItem = item
						})


				 }
				 .preferredColorScheme(.dark)
				 .ignoresSafeArea()
				 .navigationTitle("Performance")
				 .navigationBarTitleDisplayMode(.inline)
				 .sheet(item: $selectedItem) { item in
						editServe(isNewServe: false, serve: item)
				 }
				 .sheet(isPresented: $modalToggle) {
						editServe(isNewServe: true,
							 serve: serveModel(title: "", notes: "", percent: 0.0, date: .now,inServe: 0, outServe: 0, total: 0)
						)
				 }
				 .toolbar {
						ToolbarItem(placement: .navigationBarLeading) {
							 Button {
									modalToggle.toggle()
							 } label: {
									Image(systemName: "plus.square.fill.on.square.fill")
										 .resizable()
										 .frame(width: 28, height: 28)
										 .padding(.horizontal,20)
										 .tint(.blue)
							 }
						}
				 }
			}
	 }
}

	 // View remains unchanged
struct ServeDataList: View {
	 
	 @Environment(\.modelContext) var modelContext
	 @Query var serves: [serveModel]
	 let dateRange: DateRange


	 var filteredServe: [serveModel] {
			serves.filter { expense in
				 expense.date >= dateRange.startTime && expense.date <= dateRange.endTime
			}
			.sorted { $0.date > $1.date }
	 }
	 let onItemTap: (serveModel) -> Void

	 var body: some View {
			List {
				 ForEach(filteredServe) { item in
						VStack(alignment: .leading, spacing: 0) {
							 HStack(spacing: 15) {
									ZStack {
										 Rectangle()
												.frame(width: 50, height: 50)
												.cornerRadius(10)
												.foregroundStyle(Color.blue.opacity(0.1))
										 Text(String(format: "%.0f%%", item.percent))
												.bold()
												.foregroundColor(.blue)
									}

									VStack(alignment: .leading, spacing: 8) {
										 VStack {
												Text("\(item.title)")
													 .font(.system(size: 16))
										 }
										 HStack {
												Text(item.date, style: .date)
													 .font(.subheadline)
													 .foregroundStyle(Color(red: 0.4627, green: 0.8392, blue: 1.0))
												Spacer()
										 }
									}


									VStack(alignment: .leading) {

													 HStack {
															Text("In: \(item.inServe)")
																 .font(.system(size: 15))
																 .foregroundColor(.secondary)
															Text("Out: \(item.outServe)")
																 .font(.system(size: 15))
																 .foregroundColor(.secondary)
													 }
													 Text("Total Serves: \(item.total)")
															.font(.system(size: 15))
															.foregroundColor(.secondary)
												}


							 }
						}
						.contentShape(Rectangle())
						.onTapGesture {
							 onItemTap(item)
						}
						.padding(.horizontal, -5)
						.padding(.vertical, 2)
						.listRowBackground(Color.gray60.opacity(0.2))
				 }
				 .onDelete(perform: deleteItems)
			}
			.scrollIndicators(.hidden)
			.contentMargins(.top, 0)
			.padding(.top, 10)
			.overlay {
				 if filteredServe.isEmpty {
						ContentUnavailableView(label: {
							 Label("No Serves Added", systemImage: "list.bullet.rectangle.portrait")
						},
																	 description: {
							 Text("Start adding serve sessions above")
						})
						.offset(y: -30)
				 }
			}

	 }

	 private func deleteItems(at offsets: IndexSet) {
			for index in offsets {
				 let serveToDelete = serves[index]
				 modelContext.delete(serveToDelete)
			}
			do {
				 try modelContext.save()
			} catch {
				 print("Error deleting serve: \(error)")
			}
	 }
}
struct lineChart: View {
	 let linearGradient = LinearGradient(
			gradient: Gradient(colors: [Color.purple.opacity(0.4), Color.purple.opacity(0)]),
			startPoint: .top,
			endPoint: .bottom
	 )
	 var height = UIScreen.main.bounds.height

	 @Query var serves: [serveModel]
	 let dateRange: DateRange

	 var filteredServe: [serveModel] {
			serves.filter { serve in
				 serve.date >= dateRange.startTime && serve.date <= dateRange.endTime
			}
			.sorted { $0.date > $1.date }
	 }

	 @State private var animateChart: Bool = false 

	 var body: some View {
			VStack {
				 if filteredServe.isEmpty {
							 // Empty state view
						VStack(spacing: 10) {
							 Image(systemName: "chart.xyaxis.line")
									.font(.system(size: 40))
									.foregroundStyle(.purple.opacity(0.5))
							 Text("No Serve Data Yet")
									.font(.headline)
									.foregroundStyle(.gray)
							 Text("Track your serves to see your progress!")
									.font(.subheadline)
									.foregroundStyle(.gray.opacity(0.8))
						}
						.frame(width: .infinity, height: height * 0.5)
						.padding(.horizontal, 15)
						.opacity(animateChart ? 1 : 0) // Fade-in effect
						.onAppear {
							 withAnimation(.easeIn(duration: 0.5)) {
									animateChart = true
							 }
						}
				 } else {
						Chart {
							 ForEach(filteredServe) { point in
									LineMark(
										 x: .value("Time", point.date),
										 y: .value("Serve %", animateChart ? point.percent : 0)
									)
									.foregroundStyle(.purple)
									.interpolationMethod(.linear)
									.lineStyle(.init(lineWidth: 4))
									.symbol {
										 Circle()
												.foregroundStyle(.purple)
												.frame(width: 12, height: 12)
									}

									AreaMark(
										 x: .value("Time", point.date),
										 y: .value("Serve %", animateChart ? point.percent : 0) // Animate y-value
									)
									.interpolationMethod(.linear)
									.foregroundStyle(linearGradient)
							 }

							 RuleMark(y: .value("World Best", 75))
									.foregroundStyle(Color.gray20.opacity(0.2)) // Assuming gray20 is a custom color
									.lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
									.annotation(position: .top, alignment: .leading) {
										 Text("World Best: 75%")
												.font(.caption)
												.foregroundColor(.gray80.opacity(0.8)) // Assuming gray80 is a custom color
												.padding(4)
												.background(Color.white.opacity(0.8))
												.cornerRadius(4)
									}
						}
						.chartForegroundStyleScale(["Serve Percentage": Color.purple])
						.chartLegend(position: .bottom, alignment: .leading, spacing: 20)
						.chartYAxis {
							 AxisMarks(stroke: StrokeStyle(lineWidth: 0))
						}
						.chartXAxis {
							 AxisMarks(values: serves.map { $0.date }) { _ in
									AxisValueLabel(format: .dateTime.day().month())
							 }
						}
						.chartYScale(domain: 10...100)
						.padding(.horizontal, 15)
						.frame(height: 230)
						.frame(height: height * 0.5)
						.onAppear {
							 withAnimation(.easeInOut(duration: 0.8)) {
									animateChart = true
							 }
						}
				 }
			}
	 }
}

struct Card3: View {
	 let title: String
	 let color: Color
	 let icon: String
	 let progressBar: Bool
	 let goalAmount: Int
	 let currentAmount: Int
	 let textPhrase: Bool


	 var body: some View {
			VStack(alignment: .leading, spacing: 10) {
				 ZStack {
						Rectangle()
							 .frame(width: 35,height: 35)
							 .cornerRadius(10)
							 .foregroundStyle(Color.blue.opacity(0.1))
						Image(systemName: icon)
							 .resizable()
							 .frame(width: 20, height: 20)
							 .foregroundColor(.blue)
				 }
				 .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)

				 Text(title)
						.font(.system(size: 16))
						.fontWeight(.semibold)
						.foregroundColor(.white)
						.padding(.top, 4)

				 if textPhrase {
						Text("\(goalAmount)%")
							 .font(.callout)
							 .foregroundColor(color)
				 }
				 else {
						Text("\(currentAmount) out of \(goalAmount)")
							 .font(.callout)
							 .foregroundColor(color)
				 }

			}
			.padding()
			.background( Color.gray.opacity(0.16))
			.cornerRadius(15)

	 }
}

#Preview {
	 Performance()
}
