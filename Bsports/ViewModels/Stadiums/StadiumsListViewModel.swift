import Foundation
import Combine

@MainActor
class StadiumsListViewModel: ObservableObject {
    @Published var stadiums: [Stadium] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let stadiumsService = BsportsStadiumsService.shared
    
    func loadStadiums() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Load stadiums from popular leagues/countries
            // Start with England, Spain, Italy, Germany, France
            let countries = ["England", "Spain", "Italy", "Germany", "France"]
            var allStadiums: [Stadium] = []
            
            for country in countries {
                do {
                    let countryStadiums = try await stadiumsService.fetchStadiums(country: country)
                    allStadiums.append(contentsOf: countryStadiums)
                } catch {
                    // Continue with other countries if one fails
                    continue
                }
            }
            
            stadiums = allStadiums
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
