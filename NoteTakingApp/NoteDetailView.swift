//
//  NoteDetailView.swift
//  NoteTakingApp
//
//  Created by Brandon Baker on 2/3/26.
//
import SwiftUI


// This view shows the full details of a selected note
// The user can also mark the note as complete or edit it
struct NoteDetailView: View {
    
    // The ID of the note we want to display
    let noteID: UUID
    
    // ViewModel that holds all notes
    @ObservedObject var viewModel: NotesViewModel
    
    // Used to adjust styling depending on dark/light mode
    @Environment(\.colorScheme) private var colorScheme

    // This controls whether the celebration emoji appears
    @State private var showCelebration = false

    // Finds the most up-to-date version of the note from the ViewModel
    var note: Note {
        viewModel.notes.first { $0.id == noteID }!
    }

    var body: some View {
        
        // ZStack allows us to layer the emoji on top of the content
        ZStack {

            // Main scrollable note content
            ScrollView {
                VStack(spacing: 24) {

                    // Shows the note title at the top
                    // Completed notes appear crossed out and red
                    Text(note.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .italic(note.isCompleted)
                        .foregroundColor(note.isCompleted ? .red : .primary)
                        .multilineTextAlignment(.center)
                        .strikethrough(note.isCompleted)

                    // Displays the full note content
                    Text(note.content)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(note.isCompleted ? 0.6 : 1)

                    Spacer(minLength: 120)
                }
                .padding()
            }

            // Celebration emoji that appears when marking complete
            if showCelebration {
                Text("🎉")
                    .font(.system(size: 80))
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
        // Title at the top of the detail screen
        .navigationTitle("Note Details")

        // Button fixed to the bottom so it stays easy to tap
        .safeAreaInset(edge: .bottom) {
            Button {
                
                // Toggle completion status with an animation
                withAnimation(.spring()) {
                    viewModel.toggleCompletion(note: note)
                    // Show emoji only when the note is completed
                    showCelebration = note.isCompleted
                }
            } label: {
                
                // Button text changes depending on completion state
                Text(note.isCompleted ? "Mark Incomplete" : "Mark Complete")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                
                    // Button color changes depending on state
                    .background(note.isCompleted ? Color.orange : Color.green)
                    .cornerRadius(14)
                    .shadow(
                        color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.2),
                        radius: 6,
                        x: 0,
                        y: 3
                    )
            }
            .padding()
            .background(.ultraThinMaterial)
        }

        // Background gradient to make the detail screen look nicer
        .background(
            LinearGradient(
                colors: colorScheme == .dark
                    ? [Color.black, Color(.systemGray6)]
                    : [Color.white, Color(.systemGray6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )

        // Keeps the emoji state updated if completion changes elsewhere
        .onChange(of: note.isCompleted) {
            withAnimation(.spring()) {
                showCelebration = note.isCompleted
            }
        }

        // Toolbar button that allows the user to edit the note
        .toolbar {
            NavigationLink("Edit") {
                AddEditNoteView(viewModel: viewModel, noteToEdit: note)
            }
        }
    }
}
