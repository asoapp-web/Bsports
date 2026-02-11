import SwiftUI

struct TeamRowView: View {
    let team: Team
    @StateObject private var favoritesStore = BsportsFavoritesStore.shared
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: team.logoURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "sportscourt.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.fanPrimaryBlue)
            }
            .frame(width: 50, height: 50)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(team.name)
                    .font(.montserrat(.semibold, size: 16))
                    .foregroundColor(.fanTextPrimary)
                
                if let country = team.country {
                    Text(country)
                        .font(.montserratCaption)
                        .foregroundColor(.fanGrayText)
                }
            }
            
            Spacer()
            
            Button(action: {
                toggleFavorite()
            }) {
                Image(systemName: favoritesStore.isFavorite(id: team.id, kind: .team) ? "heart.fill" : "heart")
                    .font(.system(size: 20))
                    .foregroundColor(favoritesStore.isFavorite(id: team.id, kind: .team) ? .fanPrimaryBlue : .fanGrayText)
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

#Preview {
    VStack {
        TeamRowView(team: Team(
            id: "57",
            name: "Arsenal",
            country: "England"
        ))
        TeamRowView(team: Team(
            id: "65",
            name: "Manchester City",
            country: "England"
        ))
    }
    .padding(.vertical)
    .background(Color.fanBackground)
}
