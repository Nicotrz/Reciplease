//
//  CDRecipe.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 28/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import Foundation
import CoreData

class CDRecipe:NSManagedObject {

    static var selectedRow = 0
    
    static var all: [CDRecipe] {
        let request: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return recipes
    }

    static func recipeAlreadyAFavorite(withURL url: String) -> Bool {
        for recipe in CDRecipe.all where recipe.direction_url! == url {
            return true
        }
        return false
    }
}
