import SwiftUI
import Combine

struct ContentView: View {
    let messagesIntro = [
        "💬 Lisma — your reliable friend at any moment.",
        "🤝 You are not alone. We are always by your side.",
        "💭 Share your thoughts — feel relieved.",
        "❤️ Anonymous. Nonjudgmental. With support."
    ]
    
    @State private var currentIndex = 0
    @State private var opacity: Double = 0
    @State private var displayedText = ""
    @State private var charIndex = 0
    
    let switchTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    let typeTimer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("backgroundImage")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    Text(displayedText)
                        .multilineTextAlignment(.center)
                        .font(.system(.title2, design: .serif))
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding(.horizontal, 30)
                        .opacity(opacity)
                        .onReceive(switchTimer) { _ in
                            withAnimation(.easeInOut(duration: 1.0)) { opacity = 0 }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                currentIndex = (currentIndex + 1) % messagesIntro.count
                                displayedText = ""
                                charIndex = 0
                                withAnimation(.easeInOut(duration: 1.0)) { opacity = 1 }
                            }
                        }
                        .onReceive(typeTimer) { _ in
                            let full = messagesIntro[currentIndex]
                            if charIndex < full.count {
                                let idx = full.index(full.startIndex, offsetBy: charIndex)
                                displayedText.append(full[idx])
                                charIndex += 1
                            }
                        }
                    
                    Spacer()
                    
                    NavigationLink {
                        ChatView()
                    } label: {
                        Text("Let's start this journey together.")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
                .padding(.top, 100)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0)) { opacity = 1 }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
