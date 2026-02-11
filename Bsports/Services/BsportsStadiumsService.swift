import Foundation
import Combine
import os.log

@MainActor
class BsportsStadiumsService: ObservableObject {
    static let shared = BsportsStadiumsService()
    
    private let apiClient = BsportsAPIClient.shared
    private var cache: [String: (Stadium, Date)] = [:]
    private var stadiumsListCache: [String: ([Stadium], Date)] = [:] // Cache for list requests
    private let cacheTTL: TimeInterval = 7 * 24 * 60 * 60 // 7 days (aggressive caching per TS)
    private let logger = Logger(subsystem: "com.bsports", category: "StadiumsService")
    
    private init() {}
    
    func fetchStadium(id: String) async throws -> Stadium {
        let startTime = Date()
        logger.info("🏟️ [StadiumsService] fetchStadium called for ID: \(id)")
        
        // Check cache
        if let (cached, timestamp) = cache[id],
           Date().timeIntervalSince(timestamp) < cacheTTL {
            let age = Date().timeIntervalSince(timestamp)
            logger.info("💾 [StadiumsService] Cache HIT - returning stadium '\(cached.name)' (age: \(String(format: "%.1f", age / (24 * 3600)))d)")
            return cached
        }
        
        logger.info("🌐 [StadiumsService] Cache MISS - fetching from API")
        logger.info("📍 Endpoint: venues?id=\(id)")
        logger.info("⚠️ Using API-Football (limited to 100 requests/day)")
        
        do {
            // Use API-Football for stadiums (football-data.org doesn't provide venues endpoint)
            let response: APIFootballVenuesResponse = try await apiClient.fetchAPIFootball(
                endpoint: "venues?id=\(id)",
                responseType: APIFootballVenuesResponse.self
            )
            
            guard let venueDTO = response.response.first else {
                logger.error("❌ [StadiumsService] No venue found in response")
                throw BsportsAPIError.invalidResponse
            }
            
            logger.info("📥 [StadiumsService] Received stadium: \(venueDTO.name)")
            
            let stadium = Stadium(
                id: String(venueDTO.id),
                name: venueDTO.name,
                city: venueDTO.city,
                country: venueDTO.country,
                capacity: venueDTO.capacity,
                imageURL: venueDTO.image,
                address: venueDTO.address
            )
            
            logger.info("✅ [StadiumsService] Successfully converted stadium: \(stadium.name)")
            
            cache[id] = (stadium, Date())
            
            let duration = Date().timeIntervalSince(startTime)
            logger.info("⏱️ [StadiumsService] Total duration: \(String(format: "%.3f", duration))s")
            
            return stadium
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            logger.error("❌ [StadiumsService] Error fetching stadium \(id) after \(String(format: "%.3f", duration))s: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchStadiums(country: String? = nil) async throws -> [Stadium] {
        let startTime = Date()
        logger.info("🏟️ [StadiumsService] fetchStadiums called")
        logger.info("📋 Parameters: country=\(country ?? "nil")")
        
        let cacheKey = country ?? "all"
        
        // Check cache
        if let (cached, timestamp) = stadiumsListCache[cacheKey],
           Date().timeIntervalSince(timestamp) < cacheTTL {
            let age = Date().timeIntervalSince(timestamp)
            logger.info("💾 [StadiumsService] Cache HIT - returning \(cached.count) stadiums (age: \(String(format: "%.1f", age / (24 * 3600)))d)")
            return cached
        }
        
        logger.info("🌐 [StadiumsService] Cache MISS - fetching from API")
        logger.info("⚠️ Using API-Football (limited to 100 requests/day)")
        
        var endpoint = "venues"
        if let country = country {
            endpoint += "?country=\(country)"
            logger.info("📍 Endpoint: \(endpoint)")
        }
        
        do {
            let response: APIFootballVenuesResponse = try await apiClient.fetchAPIFootball(
                endpoint: endpoint,
                responseType: APIFootballVenuesResponse.self
            )
            
            logger.info("📥 [StadiumsService] Received \(response.response.count) stadiums from API")
            
            let stadiums = response.response.map { venueDTO in
                Stadium(
                    id: String(venueDTO.id),
                    name: venueDTO.name,
                    city: venueDTO.city,
                    country: venueDTO.country,
                    capacity: venueDTO.capacity,
                    imageURL: venueDTO.image,
                    address: venueDTO.address
                )
            }
            
            logger.info("✅ [StadiumsService] Successfully converted \(stadiums.count) stadiums")
            
            stadiumsListCache[cacheKey] = (stadiums, Date())
            
            // Also cache individual stadiums
            for stadium in stadiums {
                cache[stadium.id] = (stadium, Date())
            }
            
            let duration = Date().timeIntervalSince(startTime)
            logger.info("⏱️ [StadiumsService] Total duration: \(String(format: "%.3f", duration))s")
            
            return stadiums
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            logger.error("❌ [StadiumsService] Error fetching stadiums after \(String(format: "%.3f", duration))s: \(error.localizedDescription)")
            throw error
        }
    }
}
