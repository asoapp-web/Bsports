import Foundation

struct WatchedMatchRecord: Identifiable, Codable {
    let id: String
    let matchId: String
    let watchedAt: Date
    let homeTeamName: String
    let awayTeamName: String
    let homeScore: Int?
    let awayScore: Int?
    let leagueName: String?
    
    init(
        id: String? = nil,
        matchId: String,
        watchedAt: Date = Date(),
        homeTeamName: String,
        awayTeamName: String,
        homeScore: Int? = nil,
        awayScore: Int? = nil,
        leagueName: String? = nil
    ) {
        self.id = id ?? matchId
        self.matchId = matchId
        self.watchedAt = watchedAt
        self.homeTeamName = homeTeamName
        self.awayTeamName = awayTeamName
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.leagueName = leagueName
    }
}
