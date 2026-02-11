import Foundation

// MARK: - Venues Response
struct APIFootballVenuesResponse: Codable {
    let response: [APIFootballVenue]
}

struct APIFootballVenue: Codable {
    let id: Int
    let name: String
    let city: String?
    let country: String?
    let address: String?
    let capacity: Int?
    let image: String?
}
