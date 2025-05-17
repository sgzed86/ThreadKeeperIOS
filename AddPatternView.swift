import SwiftUI
import PhotosUI

struct AddPatternView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: StitchingViewModel
    
    @State private var name = ""
    @State private var designer = ""
    @State private var size = ""
    @State private var fabricCount = 14
    @State private var status = Pattern.PatternStatus.notStarted
    @State private var notes = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Pattern Details") {
                    TextField("Pattern Name", text: $name)
                    TextField("Designer (Optional)", text: $designer)
                    TextField("Size (e.g. 100x100)", text: $size)
                    Picker("Fabric Count", selection: $fabricCount) {
                        ForEach([11, 14, 16, 18, 22, 25, 28, 32], id: \.self) { count in
                            Text("\(count) count").tag(count)
                        }
                    }
                    Picker("Status", selection: $status) {
                        Text("Not Started").tag(Pattern.PatternStatus.notStarted)
                        Text("In Progress").tag(Pattern.PatternStatus.inProgress)
                        Text("Completed").tag(Pattern.PatternStatus.completed)
                    }
                }
                
                Section("Pattern Image") {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                        } else {
                            Label("Select Image", systemImage: "photo")
                        }
                    }
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Pattern")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let pattern = Pattern(
                            name: name,
                            designer: designer.isEmpty ? nil : designer,
                            size: size,
                            fabricCount: fabricCount,
                            requiredThreads: [],
                            status: status,
                            notes: notes.isEmpty ? nil : notes,
                            imageURL: nil // In a real app, you'd upload the image and get a URL
                        )
                        viewModel.addPattern(pattern)
                        dismiss()
                    }
                    .disabled(name.isEmpty || size.isEmpty)
                }
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
        }
    }
} 