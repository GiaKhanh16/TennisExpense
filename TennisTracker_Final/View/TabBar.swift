import SwiftUI

enum Tab: String, CaseIterable {
	 case PerformTab = "gauge.with.dots.needle.67percent"
	 case ExpenseTab = "chart.bar"
	 case BudgetTab = "divide.square"


			// Add a computed property to return a readable title
	 var title: String {
			switch self {
				 case .PerformTab: return "Serve"
				 case .ExpenseTab: return "Earnings"
				 case .BudgetTab: return "Stats"

			}
	 }
}

struct TabBarView: View {
	 @Binding var selectedTab: Tab

	 var body: some View {
			VStack {
				 HStack {
						ForEach(Tab.allCases, id: \.rawValue) { tab in
							 VStack(spacing:5) { // Wrap Image and Text in a VStack to stack them vertically
									Image(systemName: selectedTab == tab && tab != .PerformTab ? "\(tab.rawValue).fill" : tab.rawValue)
										 .scaleEffect(selectedTab == tab ? 1.35 : 1.3)
										 .foregroundStyle(selectedTab == tab ? .blue : .gray)

									Text(tab.title) // Add the title below the symbol
										 .font(.caption) // Smaller font size for the title
										 .foregroundStyle(selectedTab == tab ? .blue : .gray)
							 }
							 .padding(.horizontal, 25)
							 .padding(.vertical,30)
							 .onTapGesture {
									withAnimation(.easeIn(duration: 0.1)) {
										 selectedTab = tab
									}
							 }
						}
				 }
				 .frame(height: 65)
				 .background(.thinMaterial)
				 .cornerRadius(10)
				 .padding()
			}
	 }
}

#Preview {
	 TabBarView(selectedTab: .constant(.PerformTab))
}
