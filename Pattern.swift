import Foundation

struct Pattern: Identifiable, Codable {
    var id = UUID()
    var name: String
    var designer: String?
    var size: String
    var fabricCount: Int
    var requiredThreads: [DMCThread]
    var status: PatternStatus
    var notes: String?
    var imageURL: URL?
    
    enum PatternStatus: String, Codable {
        case notStarted = "Not Started"
        case inProgress = "In Progress"
        case completed = "Completed"
    }
} 