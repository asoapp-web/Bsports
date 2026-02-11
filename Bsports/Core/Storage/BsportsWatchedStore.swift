import Foundation
import Combine

@MainActor
class BsportsWatchedStore: ObservableObject {
    static let shared = BsportsWatchedStore()
    
    @Published private(set) var watchedMatches: [WatchedMatchRecord] = []
    
    private let userDefaults = UserDefaults.standard
    private let key = BsportsUserDefaultsKeys.watchedMatches
    
    private init() {
        loadWatchedMatches()
    }
    
    func addWatchedMatch(_ match: WatchedMatchRecord) {
        guard !watchedMatches.contains(where: { $0.matchId == match.matchId }) else {
            return
        }
        watchedMatches.append(match)
        saveWatchedMatches()
        BsportsHapticManager.shared.lightImpact()
    }
    
    func removeWatchedMatch(matchId: String) {
        watchedMatches.removeAll { $0.matchId == matchId }
        saveWatchedMatches()
    }
    
    func isWatched(matchId: String) -> Bool {
        watchedMatches.contains { $0.matchId == matchId }
    }
    
    func clearAll() {
        watchedMatches.removeAll()
        saveWatchedMatches()
    }
    
    private func loadWatchedMatches() {
        guard let data = userDefaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([WatchedMatchRecord].self, from: data) else {
            watchedMatches = []
            return
        }
        watchedMatches = decoded
    }
    
    private func saveWatchedMatches() {
        guard let encoded = try? JSONEncoder().encode(watchedMatches) else { return }
        userDefaults.set(encoded, forKey: key)
    }
}
