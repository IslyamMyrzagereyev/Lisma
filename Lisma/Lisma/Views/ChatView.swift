
import SwiftUI

struct MessageRow: View {
    var message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if message.role == .assistant {
                avatar
                bubble
                Spacer()
            } else {
                Spacer()
                bubble
                avatar
            }
        }
        .padding(.horizontal)
    }

    private var bubble: some View {
        Text(message.content)
            .padding(12)
            .background(message.role == .user ? Color.blue.opacity(0.8) : Color.gray.opacity(0.2))
            .foregroundColor(message.role == .user ? .white : .primary)
            .cornerRadius(16)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: message.role == .user ? .trailing : .leading)
    }

    private var avatar: some View {
        Image(systemName: message.role == .user ? "person.fill" : "sparkles")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(message.role == .user ? .blue : .gray)
    }
}

struct ChatView: View {
    @StateObject private var vm = ChatViewModel()
    @Namespace private var bottomID
    
    var body: some View {
        NavigationStack {
            VStack {
                // Сообщения
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.messages.filter { $0.role != .system }) { msg in
                                MessageRow(message: msg)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                            if vm.isTyping {
                                HStack {
                                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                                    Text("Lisma is typing...")
                                        .italic()
                                        .foregroundColor(.gray)
                                }
                                .padding(.bottom, 10)
                            }
                            Color.clear.frame(height: 1).id(bottomID)
                        }
                        .padding(.top, 10)
                    }
                    .onChange(of: vm.messages.count) { _ in
                        withAnimation { proxy.scrollTo(bottomID, anchor: .bottom) }
                    }
                }
                
                // Ввод текста
                HStack {
                    TextField("Enter a message...", text: $vm.inputText)
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                    Button {
                        Task { await vm.send() }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20))
                            .padding(10)
                            .background(vm.inputText.isEmpty ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .disabled(vm.inputText.isEmpty)
                }
                .padding()
                .background(Color(.systemBackground).opacity(0.9))
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Lisma Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: HistoryView()) {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .previewDevice("iPhone 13")  // Указываем устройство для предпросмотра
            .preferredColorScheme(.light) // Устанавливаем светлую тему для предпросмотра
    }
}
