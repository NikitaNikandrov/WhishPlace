//
//  NoteOfPlaceViewController.swift
//  HobPl
//
//  Created by Никита on 14.12.2020.
//  Copyright © 2020 BmjCstms. All rights reserved.
//

import UIKit
import RealmSwift

class NoteOfPlaceViewController: UIViewController, UITextViewDelegate {
    
    let realm = try! Realm()
    var dataOfPlaces: Results<NoteOfPlace>!
    
    var placeIndex = 0
    
    @IBOutlet weak var noteOfPlaceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataOfPlaces = realm.objects(NoteOfPlace.self)
        noteOfPlaceTextView.delegate = self
        setupTextField()
        self.hideKeyboardWhenTappedAround()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        try! self.realm.write {
            self.dataOfPlaces[placeIndex].itemNote = noteOfPlaceTextView.text
        }
    }
    
    func setupTextField() {
        let item = dataOfPlaces[placeIndex]
        if item.itemNote == "" {
            noteOfPlaceTextView.text = "Your notes of " + item.itemName
        } else {
            noteOfPlaceTextView.text = item.itemNote
        }
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
