//
//  AddEditNoteView.swift
//  NoteTakingApp
//
//  Created by Brandon Baker on 2/3/26.
//
import SwiftUI


// This view is used for both adding a new note and editing an existing one
struct AddEditNoteView: View {
    // This allows the screen to close after saving
    @Environment(\.dismiss) private var dismiss
    
    // ViewModel that stores all notes in the app
    @ObservedObject var viewModel: NotesViewModel

    // If this is not nil, the user is editing an existing note
    var noteToEdit: Note? = nil

    // State variables that hold what the user types into the form
    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        // Form layout for entering a title and content
        Form {
            // TextField for the note title
            TextField("Title", text: $title)
            
            // TextEditor for the main note content
            TextEditor(text: $content)
                .frame(height: 150) // Gives the editor enough space to type
        }
        // Title changes depending on whether you're adding or editing
        .navigationTitle(noteToEdit == nil ? "New Note" : "Edit Note")
        
        // Toolbar button to save the note
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    
                    // If noteToEdit exists, update the note instead of creating a new one
                    if let note = noteToEdit {
                        viewModel.updateNote(note: note, title: title, content: content)
                    } else {
                        // Otherwise, add a brand new note
                        viewModel.addNote(title: title, content: content)
                    }
                    // Close the screen after saving
                    dismiss()
                }
            }
        }
        // When the screen appears, fill in the text fields if editing
        .onAppear {
            if let note = noteToEdit {
                title = note.title
                content = note.content
            }
        }
    }
}
