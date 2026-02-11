import Foundation
import Combine

@MainActor
class TeamDetailViewModel: ObservableObject {
    let teamId: String
    @Published var team: Team?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let teamsService = BsportsTeamsService.shared
    
    init(teamId: String) {
        self.teamId = teamId
    }
    
    func loadTeam() async {
        isLoading = true
        errorMessage = nil
        
        do {
            team = try await teamsService.fetchTeam(id: teamId)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
