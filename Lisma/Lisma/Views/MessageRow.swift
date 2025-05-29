//import SwiftUI
//
//struct MessageRow: View {
//    var message: ChatMessage
//
//    var body: some View {
//        HStack(alignment: .bottom, spacing: 10) {
//            if message.role == .assistant {
//                avatar
//                bubble
//                Spacer()
//            } else {
//                Spacer()
//                bubble
//                avatar
//            }
//        }
//        .padding(.horizontal)
//    }
//
//    private var bubble: some View {
//        Text(message.content)
//            .padding(12)
//            .background(message.role == .user ? Color.blue.opacity(0.8) : Color.gray.opacity(0.2))
//            .foregroundColor(message.role == .user ? .white : .primary)
//            .cornerRadius(16)
//            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: message.role == .user ? .trailing : .leading)
//    }
//
//    private var avatar: some View {
//        Image(systemName: message.role == .user ? "person.fill" : "sparkles")
//            .resizable()
//            .frame(width: 30, height: 30)
//            .foregroundColor(message.role == .user ? .blue : .gray)
//    }
//}
