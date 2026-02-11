import Foundation
import Combine
import os.log

@MainActor
class BsportsLeaguesService: ObservableObject {
    static let shared = BsportsLeaguesService()
    
    private let apiClient = BsportsAPIClient.shared
    private var cache: [League] = []
    private var cacheTimestamp: Date?
    private let cacheTTL: TimeInterval = 24 * 60 * 60 // 24 hours
    private let logger = Logger(subsystem: "com.bsports", category: "LeaguesService")
    
    // Top 12 league IDs for football-data.org
    private let topLeagueIDs = [2021, 2014, 2019, 2002, 2015, 2001, 2018, 2003, 2017, 2016, 2022, 2013]
    
    private init() {}
    
    func fetchTopLeagues() async throws -> [League] {
        let startTime = Date()
        logger.info("🏆 [LeaguesService] fetchTopLeagues called")
        
        // Check cache
        if !self.cache.isEmpty,
           let timestamp = self.cacheTimestamp,
           Date().timeIntervalSince(timestamp) < cacheTTL {
            let age = Date().timeIntervalSince(timestamp)
            logger.info("💾 [LeaguesService] Cache HIT - returning \(self.cache.count) leagues (age: \(String(format: "%.1f", age / 3600))h)")
            return self.cache
        }
        
        logger.info("🌐 [LeaguesService] Cache MISS - fetching from API")
        logger.info("📍 Endpoint: competitions?plan=TIER_ONE")
        
        do {
            let response: FootballDataOrgCompetitionsResponse = try await apiClient.fetchFootballDataOrg(
                endpoint: "competitions?plan=TIER_ONE",
                responseType: FootballDataOrgCompetitionsResponse.self
            )
            
            logger.info("📥 [LeaguesService] Received \(response.competitions.count) competitions from API")
            
            let leagues = response.competitions.map { competition in
                League(
                    id: String(competition.id),
                    name: competition.name,
                    country: competition.area.name,
                    logoURL: competition.emblem,
                    season: extractSeason(from: competition.currentSeason?.startDate),
                    type: competition.type
                )
            }
            
            logger.info("✅ [LeaguesService] Successfully converted to \(leagues.count) leagues")
            logger.info("🌍 Countries: \(Set(leagues.compactMap { $0.country }).joined(separator: ", "))")
            
            cache = leagues
            cacheTimestamp = Date()
            
            let duration = Date().timeIntervalSince(startTime)
            logger.info("⏱️ [LeaguesService] Total duration: \(String(format: "%.3f", duration))s")
            
            return leagues
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            logger.error("❌ [LeaguesService] Error after \(String(format: "%.3f", duration))s: \(error.localizedDescription)")
            throw error
        }
    }
    
    func isTopLeague(id: String) -> Bool {
        guard let intId = Int(id) else {
            logger.debug("🔍 [LeaguesService] isTopLeague: invalid ID format '\(id)'")
            return false
        }
        let result = topLeagueIDs.contains(intId)
        logger.debug("🔍 [LeaguesService] isTopLeague(\(id)) = \(result)")
        return result
    }
    
    private func extractSeason(from dateString: String?) -> Int? {
        guard let dateString = dateString,
              let year = Int(dateString.prefix(4)) else {
            return nil
        }
        return year
    }
}
