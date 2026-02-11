import Foundation
import Combine

@MainActor
class TeamsListViewModel: ObservableObject {
    @Published var teams: [Team] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let teamsService = BsportsTeamsService.shared
    private let leaguesService = BsportsLeaguesService.shared
    
    func loadTeams() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let leagues = try await leaguesService.fetchTopLeagues()
            var allTeams: [Team] = []
            
            for league in leagues.prefix(5) { // Load teams from first 5 leagues
                let leagueTeams = try await teamsService.fetchTeams(leagueId: league.id)
                allTeams.append(contentsOf: leagueTeams)
            }
            
            // Remove duplicates by id
            var uniqueTeams: [Team] = []
            var seenIds = Set<String>()
            for team in allTeams {
                if !seenIds.contains(team.id) {
                    seenIds.insert(team.id)
                    uniqueTeams.append(team)
                }
            }
            teams = uniqueTeams
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
