//
//  NotesViewModel.swift
//  NoteTakingApp
//
//  Created by Brandon Baker on 2/3/26.
//

import Foundation
import Combine
import SwiftUI

// This ViewModel is basically the "manager" for all notes in the app
// It handles adding, editing, deleting, and saving notes
class NotesViewModel: ObservableObject {

    // This stores the notes in AppStorage so they stay saved even after the app closes
    @AppStorage("notesData") private var notesData: Data = Data()

    // This is the main list of notes the app uses
    // @Published means the UI updates automatically when notes change
    @Published var notes: [Note] = [] {
        didSet {
            // Anytime the notes array changes, we save it right away
            saveNotes()
        }
    }
    
    // When the app starts, load any saved notes from storage
    init() {
        loadNotes()
    }

    
    // Adds a brand new note to the list
    func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content)
        notes.append(newNote)
    }
    
    // Updates an existing note when the user edits it
    func updateNote(note: Note, title: String, content: String) {
        // Find the note in the array by matching its ID
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].title = title
            notes[index].content = content
        }
    }
    
    // Toggles whether a note is marked complete or incomplete
    func toggleCompletion(note: Note) {
        // Locate the note and flip the completion boolean
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isCompleted.toggle()
        }
    }

    // Deletes notes when the user swipes to remove them from the list
    func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }

    // Converts the notes array into JSON data and saves it
    private func saveNotes() {
        do {
            let encoded = try JSONEncoder().encode(notes)
            notesData = encoded
        } catch {
            print("Failed to save notes:", error)
        }
    }

    // Loads saved notes from AppStorage when the app opens
    private func loadNotes() {
        // If there is no saved data yet, just return
        guard !notesData.isEmpty else { return }
        do {
            // Decode the saved JSON back into an array of Note objects
            notes = try JSONDecoder().decode([Note].self, from: notesData)
        } catch {
            print("Failed to load notes:", error)
            // If something goes wrong, start with an empty list
            notes = []
        }
    }
}
