import SwiftUI

struct AddThreadView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: StitchingViewModel
    
    @State private var number = ""
    @State private var color = ""
    @State private var name = ""
    @State private var quantity = 1
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Thread Details") {
                    TextField("DMC Number", text: $number)
                        .keyboardType(.numberPad)
                    TextField("Color", text: $color)
                    TextField("Name", text: $name)
                    Stepper("Quantity: \(quantity)", value: $quantity, in: 0...100)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Thread")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let thread = DMCThread(
                            number: number,
                            color: color,
                            name: name,
                            quantity: quantity,
                            notes: notes.isEmpty ? nil : notes
                        )
                        viewModel.addThread(thread)
                        dismiss()
                    }
                    .disabled(number.isEmpty || color.isEmpty || name.isEmpty)
                }
            }
        }
    }
} 