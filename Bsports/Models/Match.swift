import Foundation

enum MatchStatus: String, Codable {
    case scheduled = "SCHEDULED"
    case live = "LIVE"
    case inPlay = "IN_PLAY"
    case paused = "PAUSED"
    case finished = "FINISHED"
    case postponed = "POSTPONED"
    case cancelled = "CANCELLED"
    
    var displayName: String {
        switch self {
        case .scheduled: return "Scheduled"
        case .live, .inPlay: return "Live"
        case .paused: return "Paused"
        case .finished: return "Finished"
        case .postponed: return "Postponed"
        case .cancelled: return "Cancelled"
        }
    }
}

struct Match: Identifiable, Codable, Equatable {
    let id: String
    let leagueId: String
    let leagueName: String
    let season: Int
    let homeTeamId: String
    let awayTeamId: String
    let homeTeamName: String
    let awayTeamName: String
    let homeTeamLogoURL: String?
    let awayTeamLogoURL: String?
    let venueId: String?
    let venueName: String?
    let date: Date
    let status: MatchStatus
    let homeScore: Int?
    let awayScore: Int?
    let attendance: Int?
    let timestamp: Date?
    
    init(
        id: String,
        leagueId: String,
        leagueName: String,
        season: Int,
        homeTeamId: String,
        awayTeamId: String,
        homeTeamName: String,
        awayTeamName: String,
        homeTeamLogoURL: String? = nil,
        awayTeamLogoURL: String? = nil,
        venueId: String? = nil,
        venueName: String? = nil,
        date: Date,
        status: MatchStatus,
        homeScore: Int? = nil,
        awayScore: Int? = nil,
        attendance: Int? = nil,
        timestamp: Date? = nil
    ) {
        self.id = id
        self.leagueId = leagueId
        self.leagueName = leagueName
        self.season = season
        self.homeTeamId = homeTeamId
        self.awayTeamId = awayTeamId
        self.homeTeamName = homeTeamName
        self.awayTeamName = awayTeamName
        self.homeTeamLogoURL = homeTeamLogoURL
        self.awayTeamLogoURL = awayTeamLogoURL
        self.venueId = venueId
        self.venueName = venueName
        self.date = date
        self.status = status
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.attendance = attendance
        self.timestamp = timestamp ?? date
    }
}
