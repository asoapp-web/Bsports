import Foundation

struct StandingsEntry: Identifiable, Codable, Equatable {
    let id: String
    let rank: Int
    let teamId: String
    let teamName: String
    let teamLogoURL: String?
    let points: Int
    let played: Int
    let won: Int
    let draw: Int
    let lost: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let goalDifference: Int
    let form: String?
    
    init(
        id: String? = nil,
        rank: Int,
        teamId: String,
        teamName: String,
        teamLogoURL: String? = nil,
        points: Int,
        played: Int,
        won: Int,
        draw: Int,
        lost: Int,
        goalsFor: Int,
        goalsAgainst: Int,
        goalDifference: Int,
        form: String? = nil
    ) {
        self.id = id ?? teamId
        self.rank = rank
        self.teamId = teamId
        self.teamName = teamName
        self.teamLogoURL = teamLogoURL
        self.points = points
        self.played = played
        self.won = won
        self.draw = draw
        self.lost = lost
        self.goalsFor = goalsFor
        self.goalsAgainst = goalsAgainst
        self.goalDifference = goalDifference
        self.form = form
    }
}
