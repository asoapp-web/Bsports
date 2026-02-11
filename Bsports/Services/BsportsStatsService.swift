import Foundation
import Combine

@MainActor
class BsportsStatsService: ObservableObject {
    static let shared = BsportsStatsService()
    
    private let favoritesStore = BsportsFavoritesStore.shared
    private let watchedStore = BsportsWatchedStore.shared
    
    private init() {}
    
    func getUserStats() -> BsportsUserStats {
        let watchedMatches = watchedStore.watchedMatches
        let favorites = favoritesStore.favorites
        
        var watchedByLeague: [String: Int] = [:]
        var watchedByTeam: [String: Int] = [:]
        var attendanceCount = 0
        
        for watched in watchedMatches {
            // By league
            if let leagueName = watched.leagueName {
                watchedByLeague[leagueName, default: 0] += 1
            }
            
            // By team (home and away)
            watchedByTeam[watched.homeTeamName, default: 0] += 1
            watchedByTeam[watched.awayTeamName, default: 0] += 1
            
            // Attendance (if scores are available, assume match had attendance data)
            if watched.homeScore != nil || watched.awayScore != nil {
                attendanceCount += 1
            }
        }
        
        return BsportsUserStats(
            totalWatchedMatches: watchedMatches.count,
            watchedMatchesByLeague: watchedByLeague,
            watchedMatchesByTeam: watchedByTeam,
            favoriteTeamsCount: favorites.filter { $0.kind == .team }.count,
            favoriteLeaguesCount: favorites.filter { $0.kind == .league }.count,
            attendanceViewedCount: attendanceCount,
            averageStadiumFill: nil // Would need capacity + attendance data
        )
    }
}
