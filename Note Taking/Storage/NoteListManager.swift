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
    
    private var noteList: [Note] = []
    
    private init() {
        loadNoteList()
    }
    
    func getNotesCount() -> Int {
        return noteList.count
    }
    
    func getNote(at index: Int) -> Note? {
        if index >= 0 && index < noteList.count {
            return noteList[index]
        }
        return nil
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
        if index >= 0 && index < noteList.count {
            noteList[index] = note
            NoteTakingStorage.storage.updateNote(with: note)
        }
    }
}
