import SwiftUI

struct KitsView: View {
    @ObservedObject var viewModel: StitchingViewModel
    @State private var showingAddKit = false
    @State private var searchText = ""
    
    var filteredKits: [Kit] {
        if searchText.isEmpty {
            return viewModel.kits
        }
        return viewModel.kits.filter { kit in
            kit.name.localizedCaseInsensitiveContains(searchText) ||
            kit.brand.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredKits) { kit in
                    NavigationLink(destination: KitDetailView(kit: kit, viewModel: viewModel)) {
                        KitRow(kit: kit)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deleteKit(kit)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Kits")
            .searchable(text: $searchText, prompt: "Search kits")
            .toolbar {
                Button {
                    showingAddKit = true
                } label: {
                    Label("Add Kit", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddKit) {
                AddKitView(viewModel: viewModel)
            }
        }
    }
}

struct KitRow: View {
    let kit: Kit
    
    var body: some View {
        HStack {
            if let imageURL = kit.imageURL {
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
                Image(systemName: "shippingbox")
                    .frame(width: 60, height: 60)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading) {
                Text(kit.name)
                    .font(.headline)
                Text(kit.brand)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(kit.status.rawValue)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}

struct KitDetailView: View {
    let kit: Kit
    @ObservedObject var viewModel: StitchingViewModel
    
    var body: some View {
        List {
            if let imageURL = kit.imageURL {
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
                LabeledContent("Brand", value: kit.brand)
                LabeledContent("Fabric Type", value: kit.fabricType)
                LabeledContent("Fabric Color", value: kit.fabricColor)
                LabeledContent("Fabric Count", value: "\(kit.fabricCount) count")
                LabeledContent("Status", value: kit.status.rawValue)
                if let purchaseDate = kit.purchaseDate {
                    LabeledContent("Purchase Date", value: purchaseDate.formatted(date: .long, time: .omitted))
                }
            }
            
            Section("Included Threads") {
                ForEach(kit.includedThreads) { thread in
                    ThreadRow(thread: thread)
                }
            }
            
            if let notes = kit.notes {
                Section("Notes") {
                    Text(notes)
                }
            }
        }
        .navigationTitle(kit.name)
    }
} 