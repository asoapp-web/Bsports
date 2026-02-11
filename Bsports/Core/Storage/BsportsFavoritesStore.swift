import Foundation
import Combine

@MainActor
class BsportsFavoritesStore: ObservableObject {
    static let shared = BsportsFavoritesStore()
    
    @Published private(set) var favorites: [Favorite] = []
    
    private let userDefaults = UserDefaults.standard
    private let key = BsportsUserDefaultsKeys.favorites
    
    private init() {
        loadFavorites()
    }
    
    func addFavorite(_ favorite: Favorite) {
        guard !favorites.contains(where: { $0.id == favorite.id && $0.kind == favorite.kind }) else {
            return
        }
        favorites.append(favorite)
        saveFavorites()
        BsportsHapticManager.shared.lightImpact()
    }
    
    func removeFavorite(id: String, kind: FavoriteKind) {
        favorites.removeAll { $0.id == id && $0.kind == kind }
        saveFavorites()
    }
    
    func isFavorite(id: String, kind: FavoriteKind) -> Bool {
        favorites.contains { $0.id == id && $0.kind == kind }
    }
    
    func favoriteLeagues() -> [Favorite] {
        favorites.filter { $0.kind == .league }
    }
    
    func favoriteTeams() -> [Favorite] {
        favorites.filter { $0.kind == .team }
    }
    
    private func loadFavorites() {
        guard let data = userDefaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Favorite].self, from: data) else {
            favorites = []
            return
        }
        favorites = decoded
    }
    
    private func saveFavorites() {
        guard let encoded = try? JSONEncoder().encode(favorites) else { return }
        userDefaults.set(encoded, forKey: key)
    }
}
