import Foundation
import SwiftUI

class StitchingViewModel: ObservableObject {
    @Published var threads: [DMCThread] = []
    @Published var patterns: [Pattern] = []
    @Published var kits: [Kit] = []
    
    init() {
        loadData()
    }
    
    func loadData() {
        // Load data from UserDefaults or other storage
        // This would be implemented with actual persistence
    }
    
    func saveData() {
        // Save data to UserDefaults or other storage
        // This would be implemented with actual persistence
    }
    
    // MARK: - Thread Management
    func addThread(_ thread: DMCThread) {
        threads.append(thread)
        saveData()
    }
    
    func updateThread(_ thread: DMCThread) {
        if let index = threads.firstIndex(where: { $0.id == thread.id }) {
            threads[index] = thread
            saveData()
        }
    }
    
    func deleteThread(_ thread: DMCThread) {
        threads.removeAll { $0.id == thread.id }
        saveData()
    }
    
    // MARK: - Pattern Management
    func addPattern(_ pattern: Pattern) {
        patterns.append(pattern)
        saveData()
    }
    
    func updatePattern(_ pattern: Pattern) {
        if let index = patterns.firstIndex(where: { $0.id == pattern.id }) {
            patterns[index] = pattern
            saveData()
        }
    }
    
    func deletePattern(_ pattern: Pattern) {
        patterns.removeAll { $0.id == pattern.id }
        saveData()
    }
    
    // MARK: - Kit Management
    func addKit(_ kit: Kit) {
        kits.append(kit)
        saveData()
    }
    
    func updateKit(_ kit: Kit) {
        if let index = kits.firstIndex(where: { $0.id == kit.id }) {
            kits[index] = kit
            saveData()
        }
    }
    
    func deleteKit(_ kit: Kit) {
        kits.removeAll { $0.id == kit.id }
        saveData()
    }
} 