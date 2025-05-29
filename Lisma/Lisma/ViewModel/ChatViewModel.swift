
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        .init(role: .system, content: """
            You are Lisma, a warm, empathetic, and nonjudgmental psychological companion and friend. \
            You are here to listen, support, and gently guide users through their thoughts and emotions. \
            You respond with kindness, understanding, and compassion, just like a trusted human friend or psychologist. \
            You avoid giving clinical diagnoses or medical advice, focusing instead on emotional support, encouragement, and reflection. \
            You help users feel heard, valued, and less alone. \
            You ask thoughtful, gentle questions when appropriate, and you respect the user’s pace and feelings. \
            Always keep your language natural, human-like, and emotionally intelligent.
            """
        ),
        // Приветственное сообщение от бота
        .init(role: .assistant, content: "Hello! I’m Lisma, your supportive companion. Whenever you need to talk, I’m here to listen and help you feel a little lighter. What’s on your mind today?")
    ]
    
    @Published var inputText: String = ""
    private let service = OpenAIService()
    
    @Published var isTyping = false
    
    func send() async {
        let userMsg = ChatMessage(role: .user, content: inputText)
        messages.append(userMsg)
        inputText = ""
        
        isTyping = true
        
        do {
            let reply = try await service.send(messages: messages)
            messages.append(reply)
        } catch {
            messages.append(.init(role: .assistant, content: "Error: \(error.localizedDescription)"))
        }
        
        isTyping = false
    }
}

