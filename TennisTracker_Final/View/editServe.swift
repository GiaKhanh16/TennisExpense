import SwiftUI
import Charts
import SwiftData



struct editServe: View {

	 var height = UIScreen.main.bounds.height
	 @Environment(\.dismiss) private var dismiss
	 @Environment(\.modelContext) var modelContext
	 let isNewServe: Bool
	 @Bindable var serve: serveModel

	 @State var totalServes: Int = 0
	 @State var successfulServes: Int = 0

	 private var serveData: [(title: String, value: Double, color: Color)] {
			[
				 (title: "In", value: servePercentage, color: .green),
				 (title: "Out", value: 100.0 - servePercentage, color: .gray)
			]
	 }


	 var servePercentage: Double {
			guard serve.total > 0 else { return 0.0 }
			return Double(serve.inServe) / Double(
				 serve.inServe + serve.outServe
			) * 100
	 }

	 var totalServe: Int {
			serve.inServe + serve.outServe
	 }

	 var body: some View {
			ScrollView {
				 VStack(spacing: 30) {
						HStack() {
							 Text("Serve Percentage")
									.font(.system(size:30))
									.bold()
							 Spacer()
							 Button("Save") {
									saveServe()

							 }
							 .tint(.green)
						}
						.padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 20))

//						List {
//							 Section("Title") {
//									TextField("Solinco TourBite", text: $earning.title)
//							 }
//						}

						VStack(alignment: .leading, spacing: 10) {
							 DatePicker(selection: $serve.date, in: ...Date.now, displayedComponents: .date) {
									Text("Select a date")
							 }

							 Text("Title")
									.font(.caption)
									.foregroundStyle(.gray)
									.frame(maxWidth: .infinity, alignment: .leading)
							 TextField("Serve with Alex...", text: $serve.title)
									.padding(.horizontal, 10)
									.padding(.vertical, 10)
									.foregroundStyle(.secondary)
									.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
						}

						VStack(alignment: .leading, spacing: 10) {

							 Text("Serve Notes")
									.font(.caption)
									.foregroundStyle(.gray)
									.frame(maxWidth: .infinity, alignment: .leading)
							 TextEditor(text: $serve.notes)
									.padding(5)
									.textFieldStyle(.roundedBorder)
									.foregroundStyle(.secondary)
									.overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
									.frame(height: 100)


						}

						VStack(alignment: .leading) {
							 Text("Input by inputs or buttons")
									.font(.caption)
									.foregroundStyle(.gray)
									.frame(maxWidth: .infinity, alignment: .leading)
							 HStack {

										 GeometryReader { geometry in
												VStack(alignment:.leading) {
													 TextField(
															"In",
															value: $serve.inServe,
															formatter: formatter
													 )
													 .frame(width: geometry.size.width * 0.4)
													 .keyboardType(.decimalPad)
													 .padding(10)
													 .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
													 .onChange(of: serve.inServe) { oldValue, newValue in
															serve.total = serve.inServe + serve.outServe
													 }

													 TextField("Out", value: $serve.outServe,
																		 formatter: formatter)
													 .frame(width: geometry.size.width * 0.4)
													 .keyboardType(.decimalPad)
													 .padding(10)
													 .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
													 .onChange(of: serve.outServe) { oldValue, newValue in
															serve.total = serve.inServe + serve.outServe
													 }
												}
										 }
//									Spacer()
									VStack(alignment: .trailing){
										 Chart(serveData, id: \..title) { serve in
												SectorMark(
													 angle: .value(serve.title, serve.value),
													 innerRadius: .ratio(0.75),
													 angularInset: 2
												)
												.cornerRadius(5)
												.foregroundStyle(serve.color)
										 }
										 .frame(width: 100, height: 100)
										 .chartBackground { chartProxy in
												GeometryReader { geometry in
													 if let anchor = chartProxy.plotFrame {
															let frame = geometry[anchor]
															Text(String(format: "%.0f%%", servePercentage))
																 .font(.title2)
																 .bold()
																 .position(x: frame.midX, y: frame.midY)
													 }
												}
										 }
										 .padding(.vertical, 5)
									}
									.padding(.vertical, -10)
							 }
							 HStack {
									Text("Total Serve: \(serve.total)")
									Text("In Serves: \(serve.inServe)")
										 .frame(alignment: .leading)
									Text("Out Serves: \(serve.outServe)")
							 }
							 .padding(.vertical, 10)
							 HStack {
									Button {
										 withAnimation {
												serve.inServe += 1
												serve.total += 1
										 }
									} label: {
										 Text("In")

												.foregroundStyle(.white)
												.frame(width: height * 0.09, height: 40)
												.font(.system(size: 20))
												.background(.green)
												.cornerRadius(5)
									}
									Button {
										 withAnimation {
												serve.outServe += 1
												serve.total += 1

										 }
									} label: {
										 Text("Out")
												.foregroundStyle(.white)
												.frame(width: height * 0.09, height: 40)
												.font(.system(size: 20))
												.background(.gray)
												.cornerRadius(5)
									}
									Button {
										 withAnimation {
												serve.inServe = 0
												serve.outServe = 0
												serve.total = 0
										 }
									} label: {
										 Text("Reset")
												.foregroundStyle(.white)
												.frame(width: height * 0.09, height: 40)
												.font(.system(size: 20))
												.background(.blue)
												.cornerRadius(5)
									}
							 }
//							 VStack(alignment: .leading, spacing: 10) {
//
//
//
//
//							 }

						}

				 }
				 .ignoresSafeArea(.keyboard, edges: .bottom)
				 .onTapGesture {
						hideKeyboard()
				 }
			}

			.padding()
	 }

	 func saveServe() {
			if isNewServe {
				 let newServe = serveModel(
						title: serve.title,
						notes: serve.notes,
						percent: servePercentage,
						date: serve.date,
						inServe: serve.inServe,
						outServe: serve.outServe,
						total: serve.total
				 )
				 modelContext.insert(newServe)
				 dismiss()
			}
			else {
				 dismiss()
			}
	 }



	 let formatter: NumberFormatter = {
			let formatter = NumberFormatter()
			formatter.numberStyle = .decimal
			formatter.maximumFractionDigits = 0 // Ensures no decimal places
			return formatter
	 }()

}

struct KeyboardAdaptive: ViewModifier {
	 @State private var keyboardHeight: CGFloat = 0

	 func body(content: Content) -> some View {
			content
				 .padding(.bottom, keyboardHeight)
				 .animation(.easeOut(duration: 0.25), value: keyboardHeight)
				 .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
						if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
							 keyboardHeight = keyboardFrame.height
						}
				 }
				 .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
						keyboardHeight = 0
				 }
	 }
}

extension View {
	 func keyboardAdaptive() -> some View {
			modifier(KeyboardAdaptive())
	 }
}

	 //
	 //var inputPercentage: Double {
	 //	 guard allBall > 0 else { return 0.0 }
	 //	 return Double(inBall) / Double(allBall) * 100
	 //}

	 //
	 //
	 //
	 //

	 //
	 //




	 //	 @State private var comment = "Notes on practice or matches"
	 //	 @State private var inBall: Int = 0
	 //	 @State private var outBall: Int = 0
	 //	 private var allBall: Int {
	 //			inBall + outBall
	 //	 }
	 //

