import Foundation
import os.log

actor BsportsAPIClient {
    static let shared = BsportsAPIClient()
    
    private var footballDataOrgRequests: [Date] = []
    private var apiFootballRequests: [Date] = []
    
    private let footballDataOrgRateLimit = 10 // per minute
    private let apiFootballDailyLimit = 100
    private let apiFootballRateLimit = 10 // per minute
    
    private let logger = Logger(subsystem: "com.bsports", category: "APIClient")
    
    private init() {}
    
    // MARK: - Football Data Org API
    
    func fetchFootballDataOrg<T: Decodable>(
        endpoint: String,
        responseType: T.Type
    ) async throws -> T {
        let startTime = Date()
        let fullURL = "https://api.football-data.org/v4/\(endpoint)"
        
        logger.info("🚀 [Football-Data.org] Starting request")
        logger.info("📍 URL: \(fullURL)")
        logger.info("📋 Endpoint: \(endpoint)")
        logger.info("📦 Response Type: \(String(describing: responseType))")
        
        // Rate limiting check
        await checkFootballDataOrgRateLimit()
        
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "FOOTBALL_DATA_ORG_KEY") as? String ??
                     ProcessInfo.processInfo.environment["FOOTBALL_DATA_ORG_KEY"] ??
                     "b69a6b0edc884938a955cdfd41a40b26"
        
        guard !apiKey.isEmpty else {
            logger.error("❌ [Football-Data.org] API key is empty")
            throw BsportsAPIError.invalidURL
        }
        
        logger.debug("🔑 API Key: \(apiKey.prefix(8))...\(apiKey.suffix(4))")
        
        guard let url = URL(string: fullURL) else {
            logger.error("❌ [Football-Data.org] Invalid URL: \(fullURL)")
            throw BsportsAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        logger.info("📤 [Football-Data.org] Sending request...")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let duration = Date().timeIntervalSince(startTime)
            let dataSize = data.count
            
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("❌ [Football-Data.org] Invalid response type")
                throw BsportsAPIError.invalidResponse
            }
            
            logger.info("📥 [Football-Data.org] Response received")
            logger.info("📊 Status Code: \(httpResponse.statusCode)")
            logger.info("📏 Data Size: \(dataSize) bytes (\(String(format: "%.2f", Double(dataSize) / 1024.0)) KB)")
            logger.info("⏱️ Duration: \(String(format: "%.3f", duration))s")
            
            // Log response headers
            if let headers = httpResponse.allHeaderFields as? [String: Any] {
                logger.debug("📋 Response Headers: \(headers.description)")
            }
            
            if httpResponse.statusCode == 429 {
                logger.warning("⚠️ [Football-Data.org] Rate limit exceeded (429)")
                await recordFootballDataOrgRequest()
                throw BsportsAPIError.rateLimitExceeded
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorBody = String(data: data, encoding: .utf8) ?? "Unable to decode error body"
                logger.error("❌ [Football-Data.org] HTTP Error \(httpResponse.statusCode)")
                logger.error("📄 Error Response Body: \(errorBody)")
                throw BsportsAPIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            await recordFootballDataOrgRequest()
            
            // Log response preview (first 500 chars)
            if let responseString = String(data: data, encoding: .utf8) {
                let preview = String(responseString.prefix(500))
                logger.debug("📄 Response Preview: \(preview)")
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decoded = try decoder.decode(T.self, from: data)
                logger.info("✅ [Football-Data.org] Successfully decoded response")
                return decoded
            } catch {
                logger.error("❌ [Football-Data.org] Decoding error: \(error.localizedDescription)")
                if let decodingError = error as? DecodingError {
                    logger.error("🔍 Decoding Error Details: \(String(describing: decodingError))")
                }
                // Log raw response for debugging
                if let responseString = String(data: data, encoding: .utf8) {
                    logger.error("📄 Raw Response: \(responseString)")
                }
                throw BsportsAPIError.decodingError(error)
            }
        } catch let error as BsportsAPIError {
            let duration = Date().timeIntervalSince(startTime)
            logger.error("❌ [Football-Data.org] API Error after \(String(format: "%.3f", duration))s: \(error.localizedDescription)")
            throw error
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            logger.error("❌ [Football-Data.org] Network Error after \(String(format: "%.3f", duration))s: \(error.localizedDescription)")
            throw BsportsAPIError.networkError(error)
        }
    }
    
    // MARK: - API Football
    
    func fetchAPIFootball<T: Decodable>(
        endpoint: String,
        responseType: T.Type
    ) async throws -> T {
        let startTime = Date()
        let fullURL = "https://v3.football.api-sports.io/\(endpoint)"
        
        logger.info("🚀 [API-Football] Starting request")
        logger.info("📍 URL: \(fullURL)")
        logger.info("📋 Endpoint: \(endpoint)")
        logger.info("📦 Response Type: \(String(describing: responseType))")
        
        // Rate limiting check
        do {
            try await checkAPIFootballLimits()
        } catch {
            logger.error("❌ [API-Football] Rate limit check failed: \(error.localizedDescription)")
            throw error
        }
        
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_FOOTBALL_KEY") as? String ??
                     ProcessInfo.processInfo.environment["API_FOOTBALL_KEY"] ??
                     "55e769e142cae26a5ed28ed8f933dd2c"
        
        guard !apiKey.isEmpty else {
            logger.error("❌ [API-Football] API key is empty")
            throw BsportsAPIError.invalidURL
        }
        
        logger.debug("🔑 API Key: \(apiKey.prefix(8))...\(apiKey.suffix(4))")
        
        guard let url = URL(string: fullURL) else {
            logger.error("❌ [API-Football] Invalid URL: \(fullURL)")
            throw BsportsAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-apisports-key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        logger.info("📤 [API-Football] Sending request...")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let duration = Date().timeIntervalSince(startTime)
            let dataSize = data.count
            
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("❌ [API-Football] Invalid response type")
                throw BsportsAPIError.invalidResponse
            }
            
            logger.info("📥 [API-Football] Response received")
            logger.info("📊 Status Code: \(httpResponse.statusCode)")
            logger.info("📏 Data Size: \(dataSize) bytes (\(String(format: "%.2f", Double(dataSize) / 1024.0)) KB)")
            logger.info("⏱️ Duration: \(String(format: "%.3f", duration))s")
            
            // Log response headers
            if let headers = httpResponse.allHeaderFields as? [String: Any] {
                logger.debug("📋 Response Headers: \(headers.description)")
            }
            
            if httpResponse.statusCode == 429 {
                logger.warning("⚠️ [API-Football] Rate limit exceeded (429)")
                await recordAPIFootballRequest()
                throw BsportsAPIError.rateLimitExceeded
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorBody = String(data: data, encoding: .utf8) ?? "Unable to decode error body"
                logger.error("❌ [API-Football] HTTP Error \(httpResponse.statusCode)")
                logger.error("📄 Error Response Body: \(errorBody)")
                throw BsportsAPIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            await recordAPIFootballRequest()
            
            // Log response preview (first 500 chars)
            if let responseString = String(data: data, encoding: .utf8) {
                let preview = String(responseString.prefix(500))
                logger.debug("📄 Response Preview: \(preview)")
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let decoded = try decoder.decode(T.self, from: data)
                logger.info("✅ [API-Football] Successfully decoded response")
                return decoded
            } catch {
                logger.error("❌ [API-Football] Decoding error: \(error.localizedDescription)")
                if let decodingError = error as? DecodingError {
                    logger.error("🔍 Decoding Error Details: \(String(describing: decodingError))")
                }
                // Log raw response for debugging
                if let responseString = String(data: data, encoding: .utf8) {
                    logger.error("📄 Raw Response: \(responseString)")
                }
                throw BsportsAPIError.decodingError(error)
            }
        } catch let error as BsportsAPIError {
            let duration = Date().timeIntervalSince(startTime)
            logger.error("❌ [API-Football] API Error after \(String(format: "%.3f", duration))s: \(error.localizedDescription)")
            throw error
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            logger.error("❌ [API-Football] Network Error after \(String(format: "%.3f", duration))s: \(error.localizedDescription)")
            throw BsportsAPIError.networkError(error)
        }
    }
    
    // MARK: - Rate Limiting
    
    private func checkFootballDataOrgRateLimit() async {
        let now = Date()
        let oneMinuteAgo = now.addingTimeInterval(-60)
        
        footballDataOrgRequests.removeAll { $0 < oneMinuteAgo }
        
        let currentCount = footballDataOrgRequests.count
        logger.debug("⏳ [Football-Data.org] Rate limit check: \(currentCount)/\(self.footballDataOrgRateLimit) requests in last minute")
        
        if currentCount >= footballDataOrgRateLimit {
            let oldestRequest = footballDataOrgRequests.min() ?? now
            let waitTime = 60 - now.timeIntervalSince(oldestRequest)
            if waitTime > 0 {
                logger.warning("⏸️ [Football-Data.org] Rate limit reached, waiting \(String(format: "%.1f", waitTime))s")
                try? await Task.sleep(nanoseconds: UInt64(waitTime * 1_000_000_000))
            }
        }
    }
    
    private func recordFootballDataOrgRequest() async {
        footballDataOrgRequests.append(Date())
        logger.debug("📝 [Football-Data.org] Recorded request. Total in last minute: \(self.footballDataOrgRequests.count)")
    }
    
    private func checkAPIFootballLimits() async throws {
        let now = Date()
        let oneMinuteAgo = now.addingTimeInterval(-60)
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        
        // Check daily limit
        let todayRequests = apiFootballRequests.filter { $0 >= startOfDay }
        logger.debug("📅 [API-Football] Daily requests: \(todayRequests.count)/\(self.apiFootballDailyLimit)")
        
        if todayRequests.count >= apiFootballDailyLimit {
            logger.error("❌ [API-Football] Daily limit exceeded: \(todayRequests.count)/\(self.apiFootballDailyLimit)")
            throw BsportsAPIError.dailyLimitExceeded
        }
        
        // Check per-minute limit
        let recentRequests = apiFootballRequests.filter { $0 >= oneMinuteAgo }
        logger.debug("⏱️ [API-Football] Requests in last minute: \(recentRequests.count)/\(self.apiFootballRateLimit)")
        
        if recentRequests.count >= apiFootballRateLimit {
            let oldestRequest = recentRequests.min() ?? now
            let waitTime = 60 - now.timeIntervalSince(oldestRequest)
            if waitTime > 0 {
                logger.warning("⏸️ [API-Football] Rate limit reached, waiting \(String(format: "%.1f", waitTime))s")
                try await Task.sleep(nanoseconds: UInt64(waitTime * 1_000_000_000))
            }
        }
    }
    
    private func recordAPIFootballRequest() async {
        apiFootballRequests.append(Date())
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let todayRequests = apiFootballRequests.filter { $0 >= startOfDay }
        let lastMinuteCount = apiFootballRequests.filter { $0 >= now.addingTimeInterval(-60) }.count
        logger.debug("📝 [API-Football] Recorded request. Daily: \(todayRequests.count)/\(self.apiFootballDailyLimit), Last minute: \(lastMinuteCount)/\(self.apiFootballRateLimit)")
    }
}
