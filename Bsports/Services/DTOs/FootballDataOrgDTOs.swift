import Foundation

// MARK: - Competitions Response
struct FootballDataOrgCompetitionsResponse: Codable {
    let competitions: [FootballDataOrgCompetition]
}

struct FootballDataOrgCompetition: Codable {
    let id: Int
    let name: String
    let code: String?
    let type: String
    let emblem: String?
    let area: FootballDataOrgArea
    let currentSeason: FootballDataOrgSeason?
}

struct FootballDataOrgArea: Codable {
    let id: Int
    let name: String
    let code: String?
}

struct FootballDataOrgSeason: Codable {
    let id: Int
    let startDate: String
    let endDate: String
    let currentMatchday: Int?
}

// MARK: - Matches Response
struct FootballDataOrgMatchesResponse: Codable {
    let matches: [FootballDataOrgMatch]
}

struct FootballDataOrgMatch: Codable {
    let id: Int
    let utcDate: String
    let status: String
    let matchday: Int?
    let stage: String?
    let homeTeam: FootballDataOrgTeam
    let awayTeam: FootballDataOrgTeam
    let score: FootballDataOrgScore?
    let competition: FootballDataOrgCompetitionInfo
    let venue: String?
    let attendance: Int?
}

struct FootballDataOrgTeam: Codable {
    let id: Int
    let name: String
    let shortName: String?
    let crest: String?
}

struct FootballDataOrgScore: Codable {
    let winner: String?
    let fullTime: FootballDataOrgScoreDetail?
}

struct FootballDataOrgScoreDetail: Codable {
    let home: Int?
    let away: Int?
}

struct FootballDataOrgCompetitionInfo: Codable {
    let id: Int
    let name: String
}

// MARK: - Standings Response
struct FootballDataOrgStandingsResponse: Codable {
    let standings: [FootballDataOrgStanding]
}

struct FootballDataOrgStanding: Codable {
    let stage: String
    let type: String
    let table: [FootballDataOrgTableEntry]
}

struct FootballDataOrgTableEntry: Codable {
    let position: Int
    let team: FootballDataOrgTeam
    let playedGames: Int
    let won: Int
    let draw: Int
    let lost: Int
    let points: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let goalDifference: Int
    let form: String?
}

// MARK: - Teams Response
struct FootballDataOrgTeamsResponse: Codable {
    let teams: [FootballDataOrgTeamDetail]
}

struct FootballDataOrgTeamDetail: Codable {
    let id: Int
    let name: String
    let shortName: String?
    let tla: String?
    let crest: String?
    let address: String?
    let website: String?
    let founded: Int?
    let clubColors: String?
    let venue: String?
    let area: FootballDataOrgArea
    let squad: [FootballDataOrgPlayer]? // Squad/lineup data
}

// MARK: - Player/Squad Response
struct FootballDataOrgPlayer: Codable {
    let id: Int
    let name: String
    let position: String?
    let dateOfBirth: String?
    let nationality: String?
    let shirtNumber: Int?
    let role: String? // "PLAYER" or "COACH"
    let marketValue: Int? // Market value in euros (if available)
    let contract: FootballDataOrgContract?
}

struct FootballDataOrgContract: Codable {
    let start: String? // ISO8601 date
    let until: String? // ISO8601 date
}
