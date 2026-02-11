import SwiftUI

struct TeamsListView: View {
    @StateObject private var viewModel = TeamsListViewModel()
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
                        Text("Loading teams...")
                            .font(.montserratCaption)
                            .foregroundColor(.fanGrayText)
                    }
                } else if filteredTeams.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "person.3")
                            .font(.system(size: 60))
                            .foregroundColor(.fanGrayText)
                        Text("No teams found")
                            .font(.montserratHeadline)
                            .foregroundColor(.fanTextPrimary)
                        Text("Try a different search")
                            .font(.montserratCaption)
                            .foregroundColor(.fanGrayText)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredTeams) { team in
                                NavigationLink(destination: TeamDetailView(team: team)) {
                                    TeamRowView(team: team)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Teams")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search teams")
            .searchBarTextColor()
            .task {
                await viewModel.loadTeams()
            }
        }
    }
    
    private var filteredTeams: [Team] {
        if searchText.isEmpty {
            return viewModel.teams
        }
        return viewModel.teams.filter { team in
            team.name.localizedCaseInsensitiveContains(searchText) ||
            (team.country?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
}

#Preview {
    TeamsListView()
}
