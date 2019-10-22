//
//  NoteTakingStorage.swift
//  Note Taking
//
//  Created by Truc on 10/20/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import Foundation
import CoreData

class NoteTakingStorage {
    static let storage: NoteTakingStorage = NoteTakingStorage()
    
    
    private var noteIndexToInt: [Int: UUID] = [:]
    private var currentIndex: Int = 0
    
    private var managedObjectContext: NSManagedObjectContext
    private var managedContextHasBeenSet: Bool = false
    
    private init() {
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    func setManagedContext(with managedObjectContext: NSManagedObjectContext ) {
        self.managedObjectContext = managedObjectContext
        self.managedContextHasBeenSet = true
        let noteList = NoteTakingCoreDataHelper.getNoteListFromCoreData(with: self.managedObjectContext)
        currentIndex = NoteTakingCoreDataHelper.count
        for (index, note) in noteList.enumerated() {
            noteIndexToInt[index] = note.id
        }
    }
    
    func addNote(with note: NoteObject ) {
        if managedContextHasBeenSet {
            noteIndexToInt[currentIndex] = note.id
            NoteTakingCoreDataHelper.createNoteInCoreData(with: note, in: self.managedObjectContext)
            currentIndex += 1
        }
    }
    
    func removeNote(at index: Int) {
        if managedContextHasBeenSet {
            if index < 0 || index > currentIndex-1 {
                return
            }
            
            guard let noteUUID = noteIndexToInt[index] else {return}
            
            NoteTakingCoreDataHelper.deleteNoteFromCoreData(with: noteUUID, from: self.managedObjectContext)
            if (index < currentIndex - 1) {
                for i in index ... currentIndex - 2 {
                    noteIndexToInt[i] = noteIndexToInt[i+1]
                }
            }
            noteIndexToInt.removeValue(forKey: currentIndex)
            currentIndex -= 1
        }
    }
    
    func getNote(at index: Int) -> NoteObject? {
        if managedContextHasBeenSet {
            if index < 0 || index > currentIndex-1 {
                return nil
            }
            
            guard let noteUUID = noteIndexToInt[index] else {return nil}
            
            let noteReadFromCoreData: NoteObject?
            
            noteReadFromCoreData = NoteTakingCoreDataHelper.getNoteFromCoreData(with: noteUUID, from: managedObjectContext)
            return noteReadFromCoreData
        }
        return nil
    }
    
    func updateNote(with note: NoteObject) {
        if managedContextHasBeenSet {
            var noteIndex : Int?
            noteIndexToInt.forEach { (index: Int, noteId: UUID) in
                if noteId == note.id {
                    noteIndex = index
                    return
                }
            }
            if noteIndex != nil {
                NoteTakingCoreDataHelper.updateNoteInCoreData(with: note, in: managedObjectContext)
            } else {
                print("Error")
            }
        }
    }

    
    func count() -> Int {
        return NoteTakingCoreDataHelper.count
    }
}
