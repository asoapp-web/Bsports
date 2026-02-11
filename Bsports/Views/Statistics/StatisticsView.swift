import SwiftUI

struct StatisticsView: View {
    @StateObject private var statsService = BsportsStatsService.shared
    @StateObject private var watchedStore = BsportsWatchedStore.shared
    @StateObject private var favoritesStore = BsportsFavoritesStore.shared
    
    private var stats: BsportsUserStats {
        statsService.getUserStats()
    }
    
    var body: some View {
        ZStack {
            Color.fanBackground
                .ignoresSafeArea()
            
            if stats.totalWatchedMatches == 0 {
                VStack(spacing: 20) {
                    Spacer()
                    
                    LottieView.emptyStatistics()
                        .frame(width: 180, height: 180)
                    
                    Text("No statistics yet")
                        .font(.montserratHeadline)
                        .foregroundColor(.fanTextPrimary)
                    
                    Text("Mark matches as watched\nto see your stats")
                        .font(.montserratBody)
                        .foregroundColor(.fanGrayText)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Stats cards
                        HStack(spacing: 12) {
                            StatCard(
                                value: "\(stats.totalWatchedMatches)",
                                title: "Watched",
                                icon: "eye.fill",
                                color: .fanPrimaryBlue
                            )
                            
                            StatCard(
                                value: "\(stats.favoriteTeamsCount)",
                                title: "Teams",
                                icon: "person.3.fill",
                                color: .fanPrimaryBlue
                            )
                            
                            StatCard(
                                value: "\(stats.favoriteLeaguesCount)",
                                title: "Leagues",
                                icon: "trophy.fill",
                                color: .fanPrimaryBlue
                            )
                        }
                        .padding(.horizontal)
                        
                        // Recent watched
                        if !watchedStore.watchedMatches.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Recently Watched")
                                    .font(.montserrat(.semibold, size: 18))
                                    .foregroundColor(.fanTextPrimary)
                                    .padding(.horizontal)
                                
                                ForEach(watchedStore.watchedMatches.prefix(5)) { watched in
                                    WatchedMatchRow(watched: watched)
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct StatCard: View {
    let value: String
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.montserrat(.bold, size: 28))
                .foregroundColor(.fanTextPrimary)
            
            Text(title)
                .font(.montserratCaption)
                .foregroundColor(.fanGrayText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            LinearGradient(
                colors: [Color.fanBackgroundCard, Color.fanPrimaryBlue.opacity(0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: .fanPrimaryBlue.opacity(0.2), radius: 8, x: 0, y: 2)
    }
}

struct WatchedMatchRow: View {
    let watched: WatchedMatchRecord
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(watched.homeTeamName) vs \(watched.awayTeamName)")
                    .font(.montserrat(.medium, size: 15))
                    .foregroundColor(.fanTextPrimary)
                
                if let leagueName = watched.leagueName {
                    Text(leagueName)
                        .font(.montserratCaption)
                        .foregroundColor(.fanGrayText)
                }
            }
            
            Spacer()
            
            if let homeScore = watched.homeScore, let awayScore = watched.awayScore {
                Text("\(homeScore) - \(awayScore)")
                    .font(.montserrat(.bold, size: 16))
                    .foregroundColor(.fanPrimaryBlue)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.fanBackgroundCard, Color.fanPrimaryBlue.opacity(0.1)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    StatisticsView()
}
