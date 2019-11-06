//
//  TableViewController.swift
//  Notes
//
//  Created by 17 on 11/4/19.
//  Copyright © 2019 17. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    var noteViewController: NoteViewController?

    var resultsController: NSFetchedResultsController<Note>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataStack.shared.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        do {
            try resultsController.performFetch()
        }
        catch { print("Error: \(error)") }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].objects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        
        let note = resultsController.object(at: indexPath)
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        noteViewController = storyboard?.instantiateViewController(identifier: "noteViewController")
        
        let note = resultsController.object(at: indexPath)
        noteViewController?.note = note
        
        self.navigationController?.pushViewController(noteViewController!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            
            let note = resultsController.object(at: indexPath)
            
            CoreDataStack.shared.delete(note: note)
            loadData()
            tableView.reloadData()
         }
    }

}
