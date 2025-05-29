import SwiftUI

struct SessionDetailView: View {
    let session: ChatSession

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(session.messages) { msg in
                    MessageRow(message: msg)
                }
            }
            .padding()
        }
        .navigationTitle("Session")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SessionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SessionDetailView(session: ChatSession(id: UUID(), date: Date(), messages: [
            .init(role: .user, content: "How are you?"),
            .init(role: .assistant, content: "I'm doing great, thank you for asking!")
        ]))
    }
}

//import SwiftUI
//
//struct SessionDetailView: View {
//    let session: ChatSession
//
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 12) {
//                ForEach(session.messages) { msg in
//                    MessageRow(message: msg)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Session")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
