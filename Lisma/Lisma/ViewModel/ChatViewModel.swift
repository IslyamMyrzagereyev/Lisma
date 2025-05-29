
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        .init(role: .system, content: """YOUR_PROMT"""
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

