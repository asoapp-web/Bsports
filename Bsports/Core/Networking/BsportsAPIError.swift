import Foundation

enum BsportsAPIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)
    case rateLimitExceeded
    case dailyLimitExceeded
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again in a minute."
        case .dailyLimitExceeded:
            return "Daily API limit reached. Data will refresh tomorrow."
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
