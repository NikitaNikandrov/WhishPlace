//
//  Realm.swift
//  HobPl
//
//  Created by Никита on 07.02.2021.
//  Copyright © 2021 BmjCstms. All rights reserved.
//

import Foundation

import RealmSwift

class NoteOfPlace: Object {
    @objc dynamic var itemName = ""
    @objc dynamic var itemNote = ""
}

class NamesArray: Object {
    var namesArray = List<String>()
}
