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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard note != nil else { return }
        
        titleTextField.text = note.title
        contentsTextView.text = note.content
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(with:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(with notification: NSNotification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        bottomConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
 
    @IBAction func handleSave(_ sender: UIBarButtonItem) {
        guard let contents = contentsTextView.text, !contents.isEmpty else { return }
        guard var title = titleTextField.text, !title.isEmpty else { return }
        
        if note != nil {
            CoreDataStack.shared.saveChanges(noteID: note.objectID, title: title, content: contentsTextView.text)
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            if title == "Title" {
                title = "No Title"
            }
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
        if titleTextField.text == "Title" || titleTextField.text == "No Title" {
            titleTextField.text = ""
            titleTextField.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Type here..."
            textView.textColor = .darkGray
        }
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleTextField.text == "" {
            titleTextField.text = "Title"
            titleTextField.textColor = .darkGray
        }
    }
    
}
