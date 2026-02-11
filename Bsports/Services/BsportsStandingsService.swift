import Foundation
import Combine

@MainActor
class BsportsStandingsService: ObservableObject {
    static let shared = BsportsStandingsService()
    
    private let apiClient = BsportsAPIClient.shared
    private var cache: [String: ([StandingsEntry], Date)] = [:]
    private let cacheTTL: TimeInterval = 15 * 60 // 15 minutes
    
    private init() {}
    
    func fetchStandings(leagueId: String, season: Int? = nil) async throws -> [StandingsEntry] {
        var endpoint = "competitions/\(leagueId)/standings"
        if let season = season {
            endpoint += "?season=\(season)"
        }
        
        let cacheKey = endpoint
        
        // Check cache
        if let (cached, timestamp) = cache[cacheKey],
           Date().timeIntervalSince(timestamp) < cacheTTL {
            return cached
        }
        
        let response: FootballDataOrgStandingsResponse = try await apiClient.fetchFootballDataOrg(
            endpoint: endpoint,
            responseType: FootballDataOrgStandingsResponse.self
        )
        
        guard let totalStanding = response.standings.first(where: { $0.type == "TOTAL" }) else {
            return []
        }
        
        let entries = totalStanding.table.map { entry in
            StandingsEntry(
                rank: entry.position,
                teamId: String(entry.team.id),
                teamName: entry.team.name,
                teamLogoURL: entry.team.crest,
                points: entry.points,
                played: entry.playedGames,
                won: entry.won,
                draw: entry.draw,
                lost: entry.lost,
                goalsFor: entry.goalsFor,
                goalsAgainst: entry.goalsAgainst,
                goalDifference: entry.goalDifference,
                form: entry.form
            )
        }
        
        cache[cacheKey] = (entries, Date())
        return entries
    }
}
