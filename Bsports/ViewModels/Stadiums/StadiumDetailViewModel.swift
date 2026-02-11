import Foundation
import Combine

@MainActor
class StadiumDetailViewModel: ObservableObject {
    let stadiumId: String
    @Published var stadium: Stadium?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let stadiumsService = BsportsStadiumsService.shared
    
    init(stadiumId: String) {
        self.stadiumId = stadiumId
    }
    
    func loadStadium() async {
        isLoading = true
        errorMessage = nil
        
        do {
            stadium = try await stadiumsService.fetchStadium(id: stadiumId)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
