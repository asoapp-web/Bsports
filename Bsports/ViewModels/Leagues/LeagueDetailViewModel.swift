import Foundation
import Combine

@MainActor
class LeagueDetailViewModel: ObservableObject {
    var leagueId: String
    @Published var standings: [StandingsEntry] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let standingsService = BsportsStandingsService.shared
    
    init(leagueId: String) {
        self.leagueId = leagueId
    }
    
    func loadStandings() async {
        isLoading = true
        errorMessage = nil
        
        do {
            standings = try await standingsService.fetchStandings(leagueId: leagueId)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
