import Foundation

struct Player: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let position: String?
    let shirtNumber: Int?
    let dateOfBirth: Date?
    let nationality: String?
    let marketValue: Int? // in euros
    let contractStart: Date?
    let contractEnd: Date?
    
    init(
        id: String,
        name: String,
        position: String? = nil,
        shirtNumber: Int? = nil,
        dateOfBirth: Date? = nil,
        nationality: String? = nil,
        marketValue: Int? = nil,
        contractStart: Date? = nil,
        contractEnd: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.position = position
        self.shirtNumber = shirtNumber
        self.dateOfBirth = dateOfBirth
        self.nationality = nationality
        self.marketValue = marketValue
        self.contractStart = contractStart
        self.contractEnd = contractEnd
    }
}
