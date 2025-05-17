import SwiftUI

struct PatternsView: View {
    @ObservedObject var viewModel: StitchingViewModel
    @State private var showingAddPattern = false
    @State private var searchText = ""
    
    var filteredPatterns: [Pattern] {
        if searchText.isEmpty {
            return viewModel.patterns
        }
        return viewModel.patterns.filter { pattern in
            pattern.name.localizedCaseInsensitiveContains(searchText) ||
            (pattern.designer?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredPatterns) { pattern in
                    NavigationLink(destination: PatternDetailView(pattern: pattern, viewModel: viewModel)) {
                        PatternRow(pattern: pattern)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deletePattern(pattern)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Patterns")
            .searchable(text: $searchText, prompt: "Search patterns")
            .toolbar {
                Button {
                    showingAddPattern = true
                } label: {
                    Label("Add Pattern", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddPattern) {
                AddPatternView(viewModel: viewModel)
            }
        }
    }
}

struct PatternRow: View {
    let pattern: Pattern
    
    var body: some View {
        HStack {
            if let imageURL = pattern.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .frame(width: 60, height: 60)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(pattern.name)
                    .font(.headline)
                if let designer = pattern.designer {
                    Text(designer)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text(pattern.status.rawValue)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}

struct PatternDetailView: View {
    let pattern: Pattern
    @ObservedObject var viewModel: StitchingViewModel
    
    var body: some View {
        List {
            if let imageURL = pattern.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray
                }
                .frame(maxHeight: 200)
                .cornerRadius(8)
            }
            
            Section("Details") {
                LabeledContent("Size", value: pattern.size)
                LabeledContent("Fabric Count", value: "\(pattern.fabricCount) count")
                LabeledContent("Status", value: pattern.status.rawValue)
            }
            
            Section("Required Threads") {
                ForEach(pattern.requiredThreads) { thread in
                    ThreadRow(thread: thread)
                }
            }
            
            if let notes = pattern.notes {
                Section("Notes") {
                    Text(notes)
                }
            }
        }
        .navigationTitle(pattern.name)
    }
} 