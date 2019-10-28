//
//  NoteListManager.swift
//  Note Taking
//
//  Created by trucht on 10/25/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import Foundation

class NoteListManager {
    
    static let shared = NoteListManager()
    
    var noteList: [Note] = []
    
    private init() {
        loadNoteList()
    }
    
    func loadNoteList() {
        noteList = NoteTakingStorage.storage.getNoteList()
    }
    
    func removeItem(at index: Int) {
        if index > 0 && index < noteList.count {
            let noteToRemove = noteList[index]
            NoteTakingStorage.storage.removeNote(with: noteToRemove)
            noteList.remove(at: index)
        }
    }
    
    func addItem(newNote: Note) {
        NoteTakingStorage.storage.addNote(with: newNote)
    }
    
    func updateItem(at index: Int, with note: Note) {
        if index > 0 && index < noteList.count {
            noteList[index] = note
            NoteTakingStorage.storage.updateNote(with: note)
        }
    }
}
