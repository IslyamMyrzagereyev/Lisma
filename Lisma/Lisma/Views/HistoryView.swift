
import SwiftUI

struct HistoryView: View {
    @StateObject private var vm = HistoryViewModel()

    var body: some View {
        List {
            ForEach(vm.sessions) { session in
                NavigationLink(destination: SessionDetailView(session: session)) {
                    VStack(alignment: .leading) {
                        Text(session.date, style: .date)
                        Text("\(session.messages.count) messages")
                            .font(.subheadline).foregroundColor(.gray)
                    }
                }
            }
            .onDelete(perform: vm.delete)
        }
        .navigationTitle("History")
        .toolbar { EditButton() }
    }
}
