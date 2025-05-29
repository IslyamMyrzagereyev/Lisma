
import Foundation

// Enum для ролей (system, user, assistant)
enum Role: String, Codable {
    case system
    case user
    case assistant
}

// Структура для сообщения
struct ChatMessage: Codable, Identifiable {
    let id = UUID()  // Уникальный идентификатор для каждого сообщения
    let role: Role
    let content: String
}

// Сервис для общения с OpenAI API
class OpenAIService {
    // Тестовый API-ключ
    private let apiKey = "API KEY"
    
    // URL для запроса
    private let apiURL = URL(string: "https://api.openai.com/v1/chat/completions")!

    // Асинхронная функция для отправки сообщений и получения ответа
    func send(messages: [ChatMessage]) async throws -> ChatMessage {
        // Проверка на пустой массив сообщений
        if messages.isEmpty {
            throw NSError(domain: "OpenAIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Messages array is empty."])
        }
        
        // Формируем тело запроса
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages.map { ["role": $0.role.rawValue, "content": $0.content] }
        ]
        
        // Преобразуем тело запроса в Data
        let data = try JSONSerialization.data(withJSONObject: body)

        // Создаем URLRequest
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        // Отправляем запрос и получаем ответ
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        // Логируем запрос и ответ для дебага
        logRequestAndResponse(request: request, responseData: responseData)
        
        // Проверяем статус код ответа
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode != 200 {
            let responseString = String(data: responseData, encoding: .utf8)
            print("Error: Status Code \(httpResponse.statusCode), Response: \(responseString ?? "No response body")")
            throw URLError(.badServerResponse)
        }

        // Структура для парсинга ответа от OpenAI API
        struct APIResponse: Codable {
            struct Choice: Codable {
                struct Message: Codable {
                    let role: String
                    let content: String
                }
                let message: Message
            }
            let choices: [Choice]
        }
        
        // Декодируем ответ от OpenAI
        let decoded = try JSONDecoder().decode(APIResponse.self, from: responseData)
        
        // Проверяем, что есть хотя бы один ответ
        guard let firstMessage = decoded.choices.first?.message else {
            throw URLError(.cannotParseResponse)
        }

        // Возвращаем сообщение от ассистента
        return ChatMessage(role: .assistant, content: firstMessage.content)
    }
    
    // Логирование запроса и ответа для дебага
    private func logRequestAndResponse(request: URLRequest, responseData: Data) {
        if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
            print("Request Body: \(bodyString)")
        }
        
        if let responseString = String(data: responseData, encoding: .utf8) {
            print("Response Body: \(responseString)")
        }
        
        if let url = request.url {
            print("Request URL: \(url.absoluteString)")
        }
    }
}
