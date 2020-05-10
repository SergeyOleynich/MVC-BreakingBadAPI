//
//  Favorites.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 10.05.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import Foundation

struct FavoriteList {
    
    static var favorites: [Character] = []
    
    static func loadFavorites() {
        if let data = PersistenceManager.shared.userDefaults.value(forKey: PersistenceManager.Keys.favorites) as? Data {
            favorites =  try! PropertyListDecoder().decode([Character].self, from: data)
        } else {
            favorites = []
        }
    }
}
