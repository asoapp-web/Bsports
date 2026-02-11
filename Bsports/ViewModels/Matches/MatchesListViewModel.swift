import Foundation
import Combine

@MainActor
class MatchesListViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showFilters = false
    
    private let fixturesService = BsportsFixturesService.shared
    private let favoritesStore = BsportsFavoritesStore.shared
    
    @Published var selectedSegment = 0
    
    func loadMatches() async {
        isLoading = true
        errorMessage = nil
        
        do {
            switch selectedSegment {
            case 0: // Today
                matches = try await fixturesService.fetchTodayMatches()
            case 1: // Upcoming
                let favoriteLeagues = favoritesStore.favoriteLeagues().map { $0.id }
                matches = try await fixturesService.fetchUpcomingMatches(leagueIds: favoriteLeagues.isEmpty ? nil : favoriteLeagues)
            case 2: // Recent
                let favoriteLeagues = favoritesStore.favoriteLeagues().map { $0.id }
                matches = try await fixturesService.fetchRecentMatches(leagueIds: favoriteLeagues.isEmpty ? nil : favoriteLeagues)
            default:
                matches = try await fixturesService.fetchTodayMatches()
            }
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func refresh() async {
        await loadMatches()
    }
}
