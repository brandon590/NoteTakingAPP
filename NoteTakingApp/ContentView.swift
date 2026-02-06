//
//  ContentView.swift
//  NoteTakingApp
//
//  Created by Brandon Baker on 2/3/26.
//

import SwiftUI

struct ContentView: View {
    
    // This ViewModel stores all the notes and keeps the UI updated
    @StateObject private var viewModel = NotesViewModel()

    // This saves the dark mode setting so it stays even after closing the app
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        // NavigationStack allows us to move between screens like list → detail view
        NavigationStack {
            // Main list that displays all saved notes
            List {
                // Loop through every note in the ViewModel
                ForEach(viewModel.notes) { note in
                    // Tapping a note takes the user to the detail screen
                    NavigationLink(value: note) {

                        // This is the layout for each note row
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {

                                // Displays the note title
                                // If the note is completed, it becomes red and crossed out
                                Text(note.title)
                                    .font(.headline)
                                    .italic(note.isCompleted)
                                    .foregroundColor(note.isCompleted ? .red : .primary)
                                    .strikethrough(note.isCompleted)

                                // Shows a preview of the note content under the title
                                Text(note.content)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2) // Keeps long notes from taking up too much space
                                    .opacity(note.isCompleted ? 0.6 : 1)

                            }

                            Spacer()

                            // If the note is completed, show a checkmark icon
                            if note.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title2)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
                // Allows the user to swipe left to delete a note
                .onDelete(perform: viewModel.deleteNotes)
            }
            // Title shown at the top of the main screen
            .navigationTitle("Notes")

            // Toolbar buttons at the top of the screen
            .toolbar {

                // Plus button to add a new note
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddEditNoteView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                // Toggle switch for dark mode
                ToolbarItem(placement: .navigationBarLeading) {
                    Toggle(isOn: $isDarkMode) {
                        // Icon changes depending on the mode
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                    .toggleStyle(.switch)
                }
            }

            // This controls what happens when a note is selected
            // It opens the NoteDetailView screen
            .navigationDestination(for: Note.self) { note in
                NoteDetailView(noteID: note.id, viewModel: viewModel)
            }
        }
        // Applies dark mode or light mode based on the toggle
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
