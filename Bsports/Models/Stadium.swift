import Foundation

struct Stadium: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let city: String?
    let country: String?
    let capacity: Int?
    let imageURL: String?
    let address: String?
    
    init(
        id: String,
        name: String,
        city: String? = nil,
        country: String? = nil,
        capacity: Int? = nil,
        imageURL: String? = nil,
        address: String? = nil
    ) {
        self.id = id
        self.name = name
        self.city = city
        self.country = country
        self.capacity = capacity
        self.imageURL = imageURL
        self.address = address
    }
    
    var fillPercentage: Double? {
        guard let capacity = capacity, capacity > 0 else { return nil }
        // This would be calculated with attendance from matches
        return nil
    }
}
