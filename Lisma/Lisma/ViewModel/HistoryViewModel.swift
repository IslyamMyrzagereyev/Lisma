import Foundation

class HistoryViewModel: ObservableObject {
    @Published var sessions: [ChatSession] = []

    private let storageKey = "chat_sessions"

    init() {
        load()
    }

    func add(session: ChatSession) {
        sessions.append(session)
        save()
    }

    func delete(at offsets: IndexSet) {
        sessions.remove(atOffsets: offsets)
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode([ChatSession].self, from: data) {
            sessions = saved
        }
    }
}

//import Foundation
//
//class HistoryViewModel: ObservableObject {
//    @Published var sessions: [ChatSession] = []
//
//    private let storageKey = "chat_sessions"
//
//    init() {
//        load()
//    }
//
//    func add(session: ChatSession) {
//        sessions.append(session)
//        save()
//    }
//
//    func delete(at offsets: IndexSet) {
//        sessions.remove(atOffsets: offsets)
//        save()
//    }
//
//    private func save() {
//        if let data = try? JSONEncoder().encode(sessions) {
//            UserDefaults.standard.set(data, forKey: storageKey)
//        }
//    }
//
//    private func load() {
//        if let data = UserDefaults.standard.data(forKey: storageKey),
//           let saved = try? JSONDecoder().decode([ChatSession].self, from: data) {
//            sessions = saved
//        }
//    }
//}
