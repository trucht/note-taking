//
//  NoteCoreDataHelper.swift
//  Note Taking
//
//  Created by Truc on 10/20/19.
//  Copyright © 2019 Truc. All rights reserved.
//

import Foundation
import CoreData

class NoteTakingCoreDataHelper {
    private(set) static var count: Int = 0
    
    static func createNoteInCoreData(with note: Note, in managedObjectContext: NSManagedObjectContext) {
        guard let noteEntity = NSEntityDescription.entity(forEntityName: "NoteEntity", in: managedObjectContext) else {return}
        
        let newNote = NSManagedObject(entity: noteEntity, insertInto: managedObjectContext)
        
        newNote.setValue(note.id, forKey: "noteId")
        newNote.setValue(note.title, forKey: "noteTitle")
        newNote.setValue(note.content, forKey: "noteContent")
        newNote.setValue(note.timeStamp, forKey: "noteTimeStamp")
        
        do {
            try managedObjectContext.save()
            count += 1
        } catch let error as NSError {
            print("Saving Error - \(error): \(error.userInfo)")
        }
    }
    
    static func updateNoteInCoreData(with note: Note, in managedObjectContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteEntity")
        
        let noteIdPredicate = NSPredicate(format: "noteId = %@", note.id as CVarArg)
        
        fetchRequest.predicate = noteIdPredicate

        do {
            let fetchedNoteList = try managedObjectContext.fetch(fetchRequest)
            let nodeToBeUpdated = fetchedNoteList[0] as! NSManagedObject
            
            nodeToBeUpdated.setValue(note.title, forKey: "noteTitle")
            nodeToBeUpdated.setValue(note.content, forKey: "noteContent")
            nodeToBeUpdated.setValue(note.timeStamp, forKey: "noteTimeStamp")
            
            try managedObjectContext.save()
            
        } catch let error as NSError {
            print("Updating Error - \(error): \(error.userInfo)")
        }
    }
    
    static func getNoteListFromCoreData(with managedObjectContext: NSManagedObjectContext) -> [Note] {
        var noteList = [Note]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteEntity")
        fetchRequest.predicate = nil
        
        do {
            let fetchedNoteListFromCoreData = try managedObjectContext.fetch(fetchRequest)
            fetchedNoteListFromCoreData.forEach { (fetchRequestResult) in
                let noteManagedObjectRead = fetchRequestResult as! NSManagedObject
                noteList.append(Note.init(
                    id:        noteManagedObjectRead.value(forKey: "noteId")        as! UUID,
                    title:     noteManagedObjectRead.value(forKey: "noteTitle")     as! String,
                    content:      noteManagedObjectRead.value(forKey: "noteContent")      as! String,
                    timeStamp: noteManagedObjectRead.value(forKey: "noteTimeStamp") as! Int64))
            }
        } catch let error as NSError {
            print("Getting Note List Error - \(error): \(error.userInfo)")
        }
        
        self.count = noteList.count
        
        return noteList
    }
    
    static func getNoteFromCoreData(with nodeId:UUID, from managedObjectContext: NSManagedObjectContext) -> Note? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteEntity")
        
        let noteIdPredicate = NSPredicate(format: "noteId = %@", nodeId as CVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try managedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeRead = fetchedNotesFromCoreData[0] as! NSManagedObject
            return Note.init(
                id:        noteManagedObjectToBeRead.value(forKey: "noteId")        as! UUID,
                title:     noteManagedObjectToBeRead.value(forKey: "noteTitle")     as! String,
                content:      noteManagedObjectToBeRead.value(forKey: "noteContent")      as! String,
                timeStamp: noteManagedObjectToBeRead.value(forKey: "noteTimeStamp") as! Int64)
        } catch let error as NSError {
            print("Getting Note Error - \(error): \(error.userInfo)")
            return nil
        }
    }
    
    static func deleteNoteFromCoreData(with noteId: UUID, from managedObjectContext: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteEntity")
        
        let noteIdAsCVarArg: CVarArg = noteId as CVarArg
        let noteIdPredicate = NSPredicate(format: "noteId == %@", noteIdAsCVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try managedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeDeleted = fetchedNotesFromCoreData[0] as! NSManagedObject
            managedObjectContext.delete(noteManagedObjectToBeDeleted)
            
            do {
                try managedObjectContext.save()
                self.count -= 1
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}
