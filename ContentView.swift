import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StitchingViewModel()
    
    var body: some View {
        TabView {
            ThreadsView(viewModel: viewModel)
                .tabItem {
                    Label("Threads", systemImage: "line.3.horizontal")
                }
            
            PatternsView(viewModel: viewModel)
                .tabItem {
                    Label("Patterns", systemImage: "square.grid.2x2")
                }
            
            KitsView(viewModel: viewModel)
                .tabItem {
                    Label("Kits", systemImage: "shippingbox")
                }
        }
    }
}

#Preview {
    ContentView()
} 