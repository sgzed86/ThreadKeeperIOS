import Foundation

struct DMCThread: Identifiable, Codable {
    var id = UUID()
    var number: String
    var color: String
    var name: String
    var quantity: Int
    var notes: String?
    
    var colorHex: String {
        // This would be expanded with actual DMC color codes
        return "#000000"
    }
} 