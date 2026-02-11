import SwiftUI

struct TeamDetailView: View {
    let team: Team
    @StateObject private var viewModel: TeamDetailViewModel
    @StateObject private var favoritesStore = BsportsFavoritesStore.shared
    
    init(team: Team) {
        self.team = team
        _viewModel = StateObject(wrappedValue: TeamDetailViewModel(teamId: team.id))
    }
    
    var body: some View {
        ZStack {
            Color.fanBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Team Header Card
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 130, height: 130)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            
                            AsyncImage(url: URL(string: team.logoURL ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Image(systemName: "sportscourt.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.fanPrimaryBlue)
                            }
                            .frame(width: 100, height: 100)
                        }
                        
                        Text(team.name)
                            .font(.montserrat(.bold, size: 24))
                            .foregroundColor(.fanTextPrimary)
                        
                        HStack(spacing: 20) {
                            if let country = team.country {
                                InfoPill(icon: "flag.fill", text: country)
                            }
                            
                            if let founded = team.founded {
                                InfoPill(icon: "calendar", text: "Est. \(founded)")
                            }
                        }
                        
                        // Favorite Button
                        Button(action: {
                            toggleFavorite()
                        }) {
                            HStack {
                                Image(systemName: favoritesStore.isFavorite(id: team.id, kind: .team) ? "heart.fill" : "heart")
                                Text(favoritesStore.isFavorite(id: team.id, kind: .team) ? "Remove from Favorites" : "Add to Favorites")
                            }
                            .font(.montserrat(.semibold, size: 16))
                            .foregroundColor(favoritesStore.isFavorite(id: team.id, kind: .team) ? .fanTextPrimary : .fanPrimaryBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(favoritesStore.isFavorite(id: team.id, kind: .team) ? Color.fanError : Color.fanPrimaryBlue.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [Color.fanBackgroundCard, Color.fanPrimaryBlue.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: .fanPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 2)
                    
                    // Squad Section
                    if viewModel.isLoading {
                        VStack(spacing: 12) {
                            LottieView.loading()
                                .frame(width: 60, height: 60)
                            Text("Loading squad...")
                                .font(.montserratCaption)
                                .foregroundColor(.fanGrayText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else if let loadedTeam = viewModel.team, let players = loadedTeam.players, !players.isEmpty {
                        SquadSection(players: players)
                    } else if let loadedTeam = viewModel.team, loadedTeam.players == nil || loadedTeam.players?.isEmpty == true {
                        // Squad not available
                        VStack(spacing: 12) {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.fanGrayText)
                            Text("Squad information not available")
                                .font(.montserratBody)
                                .foregroundColor(.fanGrayText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
                .padding()
            }
        }
        .navigationTitle(team.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadTeam()
        }
    }
    
    private func toggleFavorite() {
        if favoritesStore.isFavorite(id: team.id, kind: .team) {
            favoritesStore.removeFavorite(id: team.id, kind: .team)
        } else {
            favoritesStore.addFavorite(Favorite(
                id: team.id,
                kind: .team,
                name: team.name,
                logoURL: team.logoURL
            ))
        }
    }
}

struct SquadSection: View {
    let players: [Player]
    
    // Group players by position
    private var playersByPosition: [String: [Player]] {
        Dictionary(grouping: players) { player in
            player.position ?? "Unknown"
        }
    }
    
    private var sortedPositions: [String] {
        let order = ["Goalkeeper", "Defence", "Defender", "Midfield", "Midfielder", "Offence", "Attacker", "Forward", "Striker"]
        return playersByPosition.keys.sorted { pos1, pos2 in
            let index1 = order.firstIndex(of: pos1) ?? Int.max
            let index2 = order.firstIndex(of: pos2) ?? Int.max
            if index1 != index2 {
                return index1 < index2
            }
            return pos1 < pos2
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Squad")
                .font(.montserrat(.bold, size: 20))
                .foregroundColor(.fanTextPrimary)
                .padding(.horizontal)
            
            ForEach(sortedPositions, id: \.self) { position in
                if let positionPlayers = playersByPosition[position] {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(position)
                            .font(.montserrat(.semibold, size: 16))
                            .foregroundColor(.fanPrimaryBlue)
                            .padding(.horizontal)
                        
                        ForEach(positionPlayers.sorted(by: { ($0.shirtNumber ?? 999) < ($1.shirtNumber ?? 999) })) { player in
                            PlayerRowView(player: player)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.fanBackgroundCard, Color.fanPrimaryBlue.opacity(0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .fanPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct PlayerRowView: View {
    let player: Player
    
    var body: some View {
        HStack(spacing: 16) {
            // Shirt number
            if let number = player.shirtNumber {
                Text("\(number)")
                    .font(.montserrat(.bold, size: 18))
                    .foregroundColor(.fanTextPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.fanPrimaryBlue.opacity(0.2))
                    .cornerRadius(8)
            } else {
                Circle()
                    .fill(Color.fanGrayText.opacity(0.2))
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.montserrat(.semibold, size: 16))
                    .foregroundColor(.fanTextPrimary)
                
                if let nationality = player.nationality {
                    Text(nationality)
                        .font(.montserratCaption)
                        .foregroundColor(.fanGrayText)
                }
            }
            
            Spacer()
            
            if let age = player.dateOfBirth.flatMap({ Calendar.current.dateComponents([.year], from: $0, to: Date()).year }) {
                Text("\(age) years")
                    .font(.montserratCaption)
                    .foregroundColor(.fanGrayText)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.fanBackground, Color.fanPrimaryBlue.opacity(0.05)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct InfoPill: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.fanPrimaryBlue)
            Text(text)
                .font(.montserrat(.medium, size: 13))
                .foregroundColor(.fanGrayText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.fanPrimaryBlue.opacity(0.1))
        .cornerRadius(20)
    }
}

#Preview {
    NavigationStack {
        TeamDetailView(team: Team(
            id: "57",
            name: "Arsenal",
            founded: 1886,
            country: "England"
        ))
    }
}
