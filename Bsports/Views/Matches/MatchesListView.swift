import SwiftUI

struct MatchesListView: View {
    @StateObject private var viewModel = MatchesListViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fanBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Segment picker with red accent
                    CustomSegmentedControl(
                        selection: $viewModel.selectedSegment,
                        options: ["Today", "Upcoming", "Recent"]
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .onChange(of: viewModel.selectedSegment) {
                        Task {
                            await viewModel.loadMatches()
                        }
                    }
                    
                    if viewModel.isLoading {
                        Spacer()
                        LottieView.loading()
                            .frame(width: 80, height: 80)
                        Text("Loading matches...")
                            .font(.montserratCaption)
                            .foregroundColor(.fanGrayText)
                            .padding(.top, 8)
                        Spacer()
                    } else if viewModel.matches.isEmpty {
                        Spacer()
                        LottieView.emptyMatches()
                            .frame(width: 150, height: 150)
                        Text("No matches found")
                            .font(.montserratHeadline)
                            .foregroundColor(.fanTextPrimary)
                            .padding(.top, 16)
                        Text("Try adjusting your filters")
                            .font(.montserratCaption)
                            .foregroundColor(.fanGrayText)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(groupedMatches) { group in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(group.date)
                                            .font(.montserrat(.semibold, size: 14))
                                            .foregroundColor(.fanGrayText)
                                            .padding(.horizontal)
                                            .padding(.top, 8)
                                        
                                        ForEach(group.matches) { match in
                                            NavigationLink(destination: MatchDetailView(match: match)) {
                                                MatchCardView(match: match)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadMatches()
            }
        }
    }
    
    private var groupedMatches: [MatchGroup] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: viewModel.matches) { match in
            calendar.startOfDay(for: match.date)
        }
        
        return grouped.map { date, matches in
            MatchGroup(date: BsportsDateFormatter.shared.formatDate(date), matches: matches)
        }
        .sorted { group1, group2 in
            let date1 = viewModel.matches.first(where: { BsportsDateFormatter.shared.formatDate($0.date) == group1.date })?.date ?? Date()
            let date2 = viewModel.matches.first(where: { BsportsDateFormatter.shared.formatDate($0.date) == group2.date })?.date ?? Date()
            return date1 < date2
        }
    }
}

struct CustomSegmentedControl: View {
    @Binding var selection: Int
    let options: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<options.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = index
                    }
                }) {
                    Text(options[index])
                        .font(.montserrat(.semibold, size: 14))
                        .foregroundColor(selection == index ? .fanTextPrimary : .fanGrayText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Group {
                                if selection == index {
                                    LinearGradient(
                                        colors: [Color.fanPrimaryBlue, Color.fanPrimaryBlue.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                } else {
                                    Color.clear
                                }
                            }
                        )
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(4)
        .background(
            LinearGradient(
                colors: [Color.fanBackgroundCard, Color.fanPrimaryBlue.opacity(0.1)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
    }
}

struct MatchGroup: Identifiable {
    let id = UUID()
    let date: String
    let matches: [Match]
}

#Preview {
    MatchesListView()
}
