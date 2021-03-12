//
//  PersistenceService.swift
//  HobPl
//
//  Created by Никита on 26.09.2020.
//  Copyright © 2020 BmjCstms. All rights reserved.
//

import Foundation

class PersistenceService {
    
    enum PersistenceKeys: String {
        case placeNames
    }
    
    static var placeNames: [String] {
        set {
            UserDefaults.standard.set(newValue, forKey: PersistenceKeys.placeNames.rawValue)
        }
        get {
            return UserDefaults.standard.array(forKey: PersistenceKeys.placeNames.rawValue) as? [String] ?? []
        }
    }
}
