import Foundation

struct ChatSession: Identifiable, Codable {
    let id: UUID
    let date: Date
    var messages: [ChatMessage]
}
