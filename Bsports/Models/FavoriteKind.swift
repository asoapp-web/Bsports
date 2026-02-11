import Foundation

enum FavoriteKind: String, Codable {
    case team
    case league
}

struct Favorite: Identifiable, Codable {
    let id: String
    let kind: FavoriteKind
    let name: String
    let logoURL: String?
    
    init(id: String, kind: FavoriteKind, name: String, logoURL: String? = nil) {
        self.id = id
        self.kind = kind
        self.name = name
        self.logoURL = logoURL
    }
}
