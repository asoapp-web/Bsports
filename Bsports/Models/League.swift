import Foundation

struct League: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let country: String?
    let logoURL: String?
    let season: Int?
    let type: String?
    
    init(
        id: String,
        name: String,
        country: String? = nil,
        logoURL: String? = nil,
        season: Int? = nil,
        type: String? = nil
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.logoURL = logoURL
        self.season = season
        self.type = type
    }
}
