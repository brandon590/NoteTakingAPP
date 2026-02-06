//
//  Note.swift
//  NoteTakingApp
//
//  Created by Brandon Baker on 2/3/26.
//

import Foundation

// This struct represents a single note in the app
// Each note has a title, content, and a completion status
struct Note: Identifiable, Codable, Hashable {
    
    // Unique ID so SwiftUI can keep track of each note
    let id: UUID
    
    // Title of the note
    var title: String
    
    // Main text/content of the note
    var content: String
    
    // Tracks whether the note is marked as completed
    var isCompleted: Bool

    // Default initializer for creating a new note
    // Notes start as incomplete unless changed
    init(id: UUID = UUID(), title: String, content: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.isCompleted = isCompleted
    }
}



