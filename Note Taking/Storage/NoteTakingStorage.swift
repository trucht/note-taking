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
    
    private var managedObjectContext: NSManagedObjectContext
    private var managedContextHasBeenSet: Bool = false
    
    private var noteList: [Note] = []
    
    private init() {
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    func setManagedContext(with managedObjectContext: NSManagedObjectContext ) {
        self.managedObjectContext = managedObjectContext
        self.managedContextHasBeenSet = true
        self.noteList = NoteTakingCoreDataHelper.getNoteListFromCoreData(with: self.managedObjectContext)
    }
    
    func getNoteList() -> [Note] {
        return noteList
    }
    
    func addNote(with note: Note) {
        if managedContextHasBeenSet {
            NoteTakingCoreDataHelper.createNoteInCoreData(with: note, in: self.managedObjectContext)
        }
    }
    
    func removeNote(with note: Note) {
        if managedContextHasBeenSet {
            let noteUUID = note.id
            NoteTakingCoreDataHelper.deleteNoteFromCoreData(with: noteUUID, from: self.managedObjectContext)
        }
    }
    
    func updateNote(with note: Note) {
        if managedContextHasBeenSet {
            NoteTakingCoreDataHelper.updateNoteInCoreData(with: note, in: managedObjectContext)
        }
    }
}
