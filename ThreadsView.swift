import SwiftUI

struct ThreadsView: View {
    @ObservedObject var viewModel: StitchingViewModel
    @State private var showingAddThread = false
    @State private var searchText = ""
    
    var filteredThreads: [DMCThread] {
        if searchText.isEmpty {
            return viewModel.threads
        }
        return viewModel.threads.filter { thread in
            thread.number.localizedCaseInsensitiveContains(searchText) ||
            thread.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredThreads) { thread in
                    ThreadRow(thread: thread)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteThread(thread)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .navigationTitle("DMC Threads")
            .searchable(text: $searchText, prompt: "Search threads")
            .toolbar {
                Button {
                    showingAddThread = true
                } label: {
                    Label("Add Thread", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddThread) {
                AddThreadView(viewModel: viewModel)
            }
        }
    }
}

struct ThreadRow: View {
    let thread: DMCThread
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color(hex: thread.colorHex))
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading) {
                Text("DMC \(thread.number)")
                    .font(.headline)
                Text(thread.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("Qty: \(thread.quantity)")
                .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 