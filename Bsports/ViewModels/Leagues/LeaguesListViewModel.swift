import Foundation
import Combine

@MainActor
class LeaguesListViewModel: ObservableObject {
    @Published var leagues: [League] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let leaguesService = BsportsLeaguesService.shared
    
    func loadLeagues() async {
        isLoading = true
        errorMessage = nil
        
        do {
            leagues = try await leaguesService.fetchTopLeagues()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
