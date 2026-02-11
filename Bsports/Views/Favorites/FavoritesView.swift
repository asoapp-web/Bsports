import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesStore = BsportsFavoritesStore.shared
    @State private var selectedSegment = 0
    
    var body: some View {
        ZStack {
            Color.fanBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                CustomSegmentedControl(
                    selection: $selectedSegment,
                    options: ["Leagues", "Teams"]
                )
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                if selectedSegment == 0 {
                    if favoritesStore.favoriteLeagues().isEmpty {
                        emptyState(
                            icon: "trophy",
                            title: "No favorite leagues",
                            message: "Browse leagues and tap the heart to add favorites"
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(favoritesStore.favoriteLeagues()) { favorite in
                                    NavigationLink(destination: LeagueDetailView(league: League(
                                        id: favorite.id,
                                        name: favorite.name,
                                        logoURL: favorite.logoURL
                                    ))) {
                                        FavoriteRowView(favorite: favorite)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                } else {
                    if favoritesStore.favoriteTeams().isEmpty {
                        emptyState(
                            icon: "person.3",
                            title: "No favorite teams",
                            message: "Browse teams and tap the heart to add favorites"
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(favoritesStore.favoriteTeams()) { favorite in
                                    NavigationLink(destination: TeamDetailView(team: Team(
                                        id: favorite.id,
                                        name: favorite.name,
                                        logoURL: favorite.logoURL
                                    ))) {
                                        FavoriteRowView(favorite: favorite)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func emptyState(icon: String, title: String, message: String) -> some View {
        VStack(spacing: 20) {
            Spacer()
            
            LottieView.emptyFavorites()
                .frame(width: 150, height: 150)
            
            Text(title)
                .font(.montserratHeadline)
                .foregroundColor(.fanTextPrimary)
            
            Text(message)
                .font(.montserratBody)
                .foregroundColor(.fanGrayText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct FavoriteRowView: View {
    let favorite: Favorite
    @StateObject private var favoritesStore = BsportsFavoritesStore.shared
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: favorite.logoURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: favorite.kind == .league ? "trophy.fill" : "sportscourt.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.fanPrimaryBlue)
            }
            .frame(width: 50, height: 50)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            
            Text(favorite.name)
                .font(.montserrat(.semibold, size: 16))
                .foregroundColor(.fanTextPrimary)
            
            Spacer()
            
            Button(action: {
                favoritesStore.removeFavorite(id: favorite.id, kind: favorite.kind)
            }) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.fanPrimaryBlue)
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
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
