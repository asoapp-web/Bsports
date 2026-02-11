import SwiftUI

struct LeagueDetailView: View {
    let league: League
    @StateObject private var viewModel: LeagueDetailViewModel
    @StateObject private var favoritesStore = BsportsFavoritesStore.shared
    @State private var selectedTab = 0
    
    init(league: League) {
        self.league = league
        _viewModel = StateObject(wrappedValue: LeagueDetailViewModel(leagueId: league.id))
    }
    
    var body: some View {
        ZStack {
            Color.fanBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // League Header
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: league.logoURL ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.fanPrimaryBlue)
                        }
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(league.name)
                                .font(.montserrat(.bold, size: 20))
                                .foregroundColor(.fanTextPrimary)
                            
                            if let country = league.country {
                                Text(country)
                                    .font(.montserratBody)
                                    .foregroundColor(.fanGrayText)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            toggleFavorite()
                        }) {
                            Image(systemName: favoritesStore.isFavorite(id: league.id, kind: .league) ? "heart.fill" : "heart")
                                .font(.system(size: 24))
                                .foregroundColor(favoritesStore.isFavorite(id: league.id, kind: .league) ? .fanPrimaryBlue : .fanGrayText)
                        }
                    }
                    .padding()
                    
                    // Tab Picker
                    CustomSegmentedControl(
                        selection: $selectedTab,
                        options: ["Standings", "Fixtures"]
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                }
                .background(
                    LinearGradient(
                        colors: [Color.fanBackgroundCard, Color.fanPrimaryBlue.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                
                // Content
                if selectedTab == 0 {
                    StandingsView(leagueId: league.id, season: league.season)
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 50))
                                .foregroundColor(.fanGrayText)
                                .padding(.top, 60)
                            
                            Text("Fixtures Coming Soon")
                                .font(.montserratHeadline)
                                .foregroundColor(.fanTextPrimary)
                            
                            Text("Check back for upcoming matches")
                                .font(.montserratBody)
                                .foregroundColor(.fanGrayText)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .background(Color.fanBackground)
                }
            }
        }
        .navigationTitle(league.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func toggleFavorite() {
        if favoritesStore.isFavorite(id: league.id, kind: .league) {
            favoritesStore.removeFavorite(id: league.id, kind: .league)
        } else {
            favoritesStore.addFavorite(Favorite(
                id: league.id,
                kind: .league,
                name: league.name,
                logoURL: league.logoURL
            ))
        }
    }
}

#Preview {
    NavigationStack {
        LeagueDetailView(league: League(
            id: "2021",
            name: "Premier League",
            country: "England",
            season: 2024
        ))
    }
}
