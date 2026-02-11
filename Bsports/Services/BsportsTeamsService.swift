import Foundation
import Combine
import os.log

@MainActor
class BsportsTeamsService: ObservableObject {
    static let shared = BsportsTeamsService()
    
    private let apiClient = BsportsAPIClient.shared
    private var cache: [String: (Team, Date)] = [:]
    private var leagueTeamsCache: [String: ([Team], Date)] = [:]
    private let cacheTTL: TimeInterval = 24 * 60 * 60 // 24 hours (aggressive caching per TS)
    private let logger = Logger(subsystem: "com.bsports", category: "TeamsService")
    
    private init() {}
    
    func fetchTeam(id: String) async throws -> Team {
        let startTime = Date()
        logger.info("👥 [TeamsService] fetchTeam called for ID: \(id)")
        
        // Check cache
        if let (cached, timestamp) = cache[id],
           Date().timeIntervalSince(timestamp) < cacheTTL {
            let age = Date().timeIntervalSince(timestamp)
            logger.info("💾 [TeamsService] Cache HIT - returning team '\(cached.name)' (age: \(String(format: "%.1f", age / 3600))h)")
            return cached
        }
        
        logger.info("🌐 [TeamsService] Cache MISS - fetching from API")
        logger.info("📍 Endpoint: teams/\(id)")
        
        do {
            let teamDTO: FootballDataOrgTeamDetail = try await apiClient.fetchFootballDataOrg(
                endpoint: "teams/\(id)",
                responseType: FootballDataOrgTeamDetail.self
            )
            
            let tla = teamDTO.tla ?? "N/A"
            logger.info("📥 [TeamsService] Received team data: \(teamDTO.name) (\(tla))")
            
            // Parse squad/players if available
            let players: [Player]? = teamDTO.squad?.compactMap { playerDTO in
                convertToPlayer(from: playerDTO)
            }
            
            if let players = players, !players.isEmpty {
                logger.info("👤 [TeamsService] Parsed \(players.count) players from squad")
            }
            
            let team = Team(
                id: String(teamDTO.id),
                name: teamDTO.name,
                shortName: teamDTO.shortName ?? teamDTO.tla,
                logoURL: teamDTO.crest,
                venueId: nil,
                founded: teamDTO.founded,
                country: teamDTO.area.name,
                players: players
            )
            
            let countryName = team.country ?? "unknown"
            logger.info("✅ [TeamsService] Successfully converted team: \(team.name) from \(countryName)")
            
            cache[id] = (team, Date())
            
            let duration = Date().timeIntervalSince(startTime)
            logger.info("⏱️ [TeamsService] Total duration: \(String(format: "%.3f", duration))s")
            
            return team
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            logger.error("❌ [TeamsService] Error fetching team \(id) after \(String(format: "%.3f", duration))s: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchTeams(leagueId: String) async throws -> [Team] {
        let startTime = Date()
        logger.info("👥 [TeamsService] fetchTeams called for league ID: \(leagueId)")
        
        let cacheKey = leagueId
        
        // Check cache
        if let (cached, timestamp) = leagueTeamsCache[cacheKey],
           Date().timeIntervalSince(timestamp) < cacheTTL {
            let age = Date().timeIntervalSince(timestamp)
            logger.info("💾 [TeamsService] Cache HIT - returning \(cached.count) teams for league \(leagueId) (age: \(String(format: "%.1f", age / 3600))h)")
            return cached
        }
        
        logger.info("🌐 [TeamsService] Cache MISS - fetching from API")
        logger.info("📍 Endpoint: competitions/\(leagueId)/teams")
        
        do {
            let response: FootballDataOrgTeamsResponse = try await apiClient.fetchFootballDataOrg(
                endpoint: "competitions/\(leagueId)/teams",
                responseType: FootballDataOrgTeamsResponse.self
            )
            
            logger.info("📥 [TeamsService] Received \(response.teams.count) teams from API")
            
            let teams = response.teams.map { teamDTO in
                // Parse squad if available
                let players: [Player]? = teamDTO.squad?.compactMap { playerDTO in
                    convertToPlayer(from: playerDTO)
                }
                
                return Team(
                    id: String(teamDTO.id),
                    name: teamDTO.name,
                    shortName: teamDTO.shortName ?? teamDTO.tla,
                    logoURL: teamDTO.crest,
                    venueId: nil,
                    founded: teamDTO.founded,
                    country: teamDTO.area.name,
                    players: players
                )
            }
            
            logger.info("✅ [TeamsService] Successfully converted \(teams.count) teams")
            logger.info("🌍 Countries: \(Set(teams.compactMap { $0.country }).joined(separator: ", "))")
            
            leagueTeamsCache[cacheKey] = (teams, Date())
            
            let duration = Date().timeIntervalSince(startTime)
            logger.info("⏱️ [TeamsService] Total duration: \(String(format: "%.3f", duration))s")
            
            return teams
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            logger.error("❌ [TeamsService] Error fetching teams for league \(leagueId) after \(String(format: "%.3f", duration))s: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Player Conversion
    
    private func convertToPlayer(from dto: FootballDataOrgPlayer) -> Player? {
        // Skip coaches, only include players
        if dto.role == "COACH" {
            return nil
        }
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        
        var dateOfBirth: Date?
        if let dobString = dto.dateOfBirth {
            dateOfBirth = dateFormatter.date(from: dobString)
        }
        
        var contractStart: Date?
        if let startString = dto.contract?.start {
            contractStart = dateFormatter.date(from: startString)
        }
        
        var contractEnd: Date?
        if let endString = dto.contract?.until {
            contractEnd = dateFormatter.date(from: endString)
        }
        
        return Player(
            id: String(dto.id),
            name: dto.name,
            position: dto.position,
            shirtNumber: dto.shirtNumber,
            dateOfBirth: dateOfBirth,
            nationality: dto.nationality,
            marketValue: dto.marketValue,
            contractStart: contractStart,
            contractEnd: contractEnd
        )
    }
}
