//
//  CDRecipe.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 28/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import Foundation
import CoreData

// Object Registered for CoreData
class CDRecipe: NSManagedObject {

    // MARK: Enumeration
    
    enum OriginList {
        case favorite
        case search
    }

    // MARK: Private Properties

    // Array with all the recipes recorded on CoreData
    private static var all: [CDRecipe] {
        let request: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        let sort = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sort]
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return recipes
    }

    // MARK: Public Properties
    
    // Selected row on Favorite
    static var selectedRow = 0
    
    // Number of records registered on CoreData
    static var numberOfRecords: Int {
        return CDRecipe.all.count
    }

    // MARK: Public Methods

    static func saveContext() -> Bool {
        do {
            try AppDelegate.viewContext.save()
            return true
        } catch {
            return false
        }
    }

    // Is the recipe with the url already a favorite?
    static func recipeAlreadyAFavorite(withURL URL: String) -> Bool {
        for recipe in CDRecipe.all where recipe.direction_url! == URL {
            return true
        }
        return false
    }
    
    // Save a new favorite on CoreData and send back false in case of error
    static func saveFavorite(fromOrigin origin: OriginList) {
        let order = CDRecipe.all.count
        let newFavorite = CDRecipe(context: AppDelegate.viewContext)
        switch origin {
        case .favorite:
            AppDelegate.viewContext.rollback()
        case .search:
            let indexData = RecipesService.shared.selectedRow
            newFavorite.name = RecipesService.shared.getName(atIndex: indexData)
            newFavorite.ingredients_detail = RecipesService.shared.getFullIngredients(atindex: indexData)
            newFavorite.ingredients_list = RecipesService.shared.getIngredients(atindex: indexData)
            newFavorite.preparation_time = RecipesService.shared.getPreparationTime(atIndex: indexData)
            newFavorite.direction_url = RecipesService.shared.getDirectionUrl(atindex: indexData)
            newFavorite.image_url = RecipesService.shared.getImageUrl(atIndex: indexData)
            newFavorite.order = Int32(order)
        }
    }

    static func setNewOrder(fromValue: Int, toValue: Int) {
        let tampon = 99999
        updateIndex(oldValue: fromValue, newValue: tampon)
        if toValue < fromValue {
            for index in (toValue...fromValue - 1).reversed() {
                updateIndex(oldValue: index, newValue: index + 1)
            }
        } else if toValue > fromValue {
            for index in fromValue + 1...toValue {
                updateIndex(oldValue: index, newValue: index - 1)
            }
        }
        updateIndex(oldValue: tampon, newValue: toValue)
    }

     static func updateIndex(oldValue: Int, newValue: Int) {
        let request: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "order = %d", oldValue)
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else {
            return
        }
        let recipeToUpdate = recipes[0] as NSManagedObject
        recipeToUpdate.setValue(newValue, forKey: "order")
        if CDRecipe.saveContext() {
            print("=======")
            print("Update object to move...")
            print(oldValue)
            print("Moved to \(newValue)")
            print("Success!")
            print("=======")
        }
    }

    static func recalculateIndex() {
        for (indexRecipe, recipe) in all.enumerated() {
            updateIndex(oldValue: Int(recipe.order), newValue: indexRecipe)
        }
    }
    
    // Delete a favorite with index from CoreData and send back false in case of error
    static func deleteFavorite(fromOrigin origin: OriginList, atIndex index: Int ) {
        let request: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        let URL: String
        switch origin {
        case .favorite:
            URL = CDRecipe.getDirectionsUrl(atIndex: index)
        case .search:
            URL = RecipesService.shared.getDirectionUrl(atindex: index)
        }
        request.predicate = NSPredicate(format: "direction_url = %@", URL)
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else {
            return
        }
        let recipeToDelete = recipes[0] as NSManagedObject
        AppDelegate.viewContext.delete(recipeToDelete)
    }

    // Get the title of the requested recipe
    static func getTitle(atIndex index: Int) -> String {
        guard let title = CDRecipe.all[index].name else {
            return ""
        }
        print("=============")
        print("\(title) is at index \(CDRecipe.all[index].order)")
        print("=============")
        return title
    }

    // Get the ingredients of the requested recipe
    static func getIngredients(atIndex index: Int) -> String {
        guard let ingredients = CDRecipe.all[index].ingredients_list else {
            return ""
        }
        return ingredients
    }

    // Get the detailed ingredients of the requested recipe
    static func getFullIngredients(atIndex index: Int) -> String {
        guard let ingredients = CDRecipe.all[index].ingredients_detail else {
            return ""
        }
        return ingredients
    }

    // Get the image URL of the requested recipe
    static func getImageURL(atIndex index: Int) -> String {
        guard let imageURL = CDRecipe.all[index].image_url else {
            return ""
        }
        return imageURL
    }

    // Get the direction URL from the requested recipe
    static func getDirectionsUrl(atIndex index: Int) -> String {
        guard let directionsURL = CDRecipe.all[index].direction_url else {
            return ""
        }
        return directionsURL
    }

    // Get the preparation time from the requested recipe
    static func getPreparationTime(atIndex index: Int) -> String {
        guard let preparationTime = CDRecipe.all[index].preparation_time else {
            return ""
        }
        return preparationTime
    }
}
