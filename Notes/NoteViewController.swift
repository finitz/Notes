//
//  NoteViewController.swift
//  Notes
//
//  Created by 17 on 11/4/19.
//  Copyright © 2019 17. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var note: Note!
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard note != nil else { return }
        
        titleTextField.text = note.title
        contentsTextView.text = note.content
    }
    
 
    @IBAction func handleSave(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        guard let contents = contentsTextView.text, !contents.isEmpty else { return }
        
        if note != nil {
            CoreDataStack.shared.saveChanges(noteID: note.objectID, title: title, content: contentsTextView.text)
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            CoreDataStack.shared.addNewNote(title: title, contents: contents)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type here..." {
            textView.text = ""
            textView.textColor = .black
        }
        saveButton.isEnabled = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if titleTextField.text == "Title" {
            titleTextField.text = ""
            titleTextField.textColor = .black
        }
    }
    
    
}
