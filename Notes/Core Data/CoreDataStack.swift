//
//  CoreDataStack.swift
//  Notes
//
//  Created by 17 on 11/5/19.
//  Copyright © 2019 17. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
        }
        return container
    }()
    
    
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveChanges(noteID: NSManagedObjectID, title: String, content: String) {
        let noteToBeChanged = managedContext.object(with: noteID) as! Note
        noteToBeChanged.content = content
        saveContext()
    }
    
    func addNewNote(title: String, contents: String) {
        let newNote = Note(context: managedContext)
        newNote.title = title
        newNote.content = contents
        saveContext()
    }
    
    func saveContext() {
        do {
            try managedContext.save()
            managedContext.refreshAllObjects()
            
        }
        catch { print("Error: \(error)") }
    }
}

