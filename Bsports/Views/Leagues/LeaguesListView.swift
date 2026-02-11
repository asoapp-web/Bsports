import SwiftUI

struct LeaguesListView: View {
    @StateObject private var viewModel = LeaguesListViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fanBackground
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    VStack {
                        LottieView.loading()
                            .frame(width: 80, height: 80)
                        Text("Loading leagues...")
                            .font(.montserratCaption)
                            .foregroundColor(.fanGrayText)
                    }
                } else if filteredLeagues.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "trophy")
                            .font(.system(size: 60))
                            .foregroundColor(.fanGrayText)
                        Text("No leagues found")
                            .font(.montserratHeadline)
                            .foregroundColor(.fanTextPrimary)
                        Text("Try a different search")
                            .font(.montserratCaption)
                            .foregroundColor(.fanGrayText)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredLeagues) { league in
                                NavigationLink(destination: LeagueDetailView(league: league)) {
                                    LeagueRowView(league: league)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Leagues")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search leagues")
            .searchBarTextColor()
            .task {
                await viewModel.loadLeagues()
            }
        }
    }
    
    private var filteredLeagues: [League] {
        if searchText.isEmpty {
            return viewModel.leagues
        }
        return viewModel.leagues.filter { league in
            league.name.localizedCaseInsensitiveContains(searchText) ||
            (league.country?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
}

#Preview {
    LeaguesListView()
}
