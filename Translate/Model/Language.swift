import Foundation


struct Language: Hashable, Identifiable, Codable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "code"
        case name
    }
}
