import SwiftUI

struct LeagueRowView: View {
    let league: League
    @StateObject private var favoritesStore = BsportsFavoritesStore.shared
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: league.logoURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.fanPrimaryBlue)
            }
            .frame(width: 50, height: 50)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(league.name)
                    .font(.montserrat(.semibold, size: 16))
                    .foregroundColor(.fanTextPrimary)
                
                if let country = league.country {
                    Text(country)
                        .font(.montserratCaption)
                        .foregroundColor(.fanGrayText)
                }
            }
            
            Spacer()
            
            Button(action: {
                toggleFavorite()
            }) {
                Image(systemName: favoritesStore.isFavorite(id: league.id, kind: .league) ? "heart.fill" : "heart")
                    .font(.system(size: 20))
                    .foregroundColor(favoritesStore.isFavorite(id: league.id, kind: .league) ? .fanPrimaryBlue : .fanGrayText)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.fanGrayText)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.fanBackgroundCard, Color.fanPrimaryBlue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: .fanPrimaryBlue.opacity(0.1), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
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
    VStack {
        LeagueRowView(league: League(
            id: "2021",
            name: "Premier League",
            country: "England",
            season: 2024
        ))
        LeagueRowView(league: League(
            id: "2014",
            name: "La Liga",
            country: "Spain",
            season: 2024
        ))
    }
    .padding(.vertical)
    .background(Color.fanBackground)
}
