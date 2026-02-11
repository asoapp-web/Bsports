import Foundation

struct Team: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let shortName: String?
    let logoURL: String?
    let venueId: String?
    let founded: Int?
    let country: String?
    let players: [Player]? // Squad/lineup
    
    init(
        id: String,
        name: String,
        shortName: String? = nil,
        logoURL: String? = nil,
        venueId: String? = nil,
        founded: Int? = nil,
        country: String? = nil,
        players: [Player]? = nil
    ) {
        self.id = id
        self.name = name
        self.shortName = shortName
        self.logoURL = logoURL
        self.venueId = venueId
        self.founded = founded
        self.country = country
        self.players = players
    }
}
