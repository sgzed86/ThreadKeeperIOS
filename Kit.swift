import Foundation

struct Kit: Identifiable, Codable {
    var id = UUID()
    var name: String
    var brand: String
    var includedThreads: [DMCThread]
    var fabricType: String
    var fabricColor: String
    var fabricCount: Int
    var status: KitStatus
    var purchaseDate: Date?
    var notes: String?
    var imageURL: URL?
    
    enum KitStatus: String, Codable {
        case new = "New"
        case inProgress = "In Progress"
        case completed = "Completed"
    }
} 