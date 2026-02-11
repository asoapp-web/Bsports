import Foundation

struct BsportsUserStats: Codable {
    let totalWatchedMatches: Int
    let watchedMatchesByLeague: [String: Int]
    let watchedMatchesByTeam: [String: Int]
    let favoriteTeamsCount: Int
    let favoriteLeaguesCount: Int
    let attendanceViewedCount: Int
    let averageStadiumFill: Double?
    
    init(
        totalWatchedMatches: Int = 0,
        watchedMatchesByLeague: [String: Int] = [:],
        watchedMatchesByTeam: [String: Int] = [:],
        favoriteTeamsCount: Int = 0,
        favoriteLeaguesCount: Int = 0,
        attendanceViewedCount: Int = 0,
        averageStadiumFill: Double? = nil
    ) {
        self.totalWatchedMatches = totalWatchedMatches
        self.watchedMatchesByLeague = watchedMatchesByLeague
        self.watchedMatchesByTeam = watchedMatchesByTeam
        self.favoriteTeamsCount = favoriteTeamsCount
        self.favoriteLeaguesCount = favoriteLeaguesCount
        self.attendanceViewedCount = attendanceViewedCount
        self.averageStadiumFill = averageStadiumFill
    }
}
