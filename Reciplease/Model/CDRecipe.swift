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

    static func saveContext() {
            try? AppDelegate.viewContext.save()
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
            newFavorite.ingredients_detail = RecipesService.shared.getFullIngredients(atIndex: indexData)
            newFavorite.ingredients_list = RecipesService.shared.getIngredients(atIndex: indexData)
            newFavorite.preparation_time = RecipesService.shared.getPreparationTime(atIndex: indexData)
            newFavorite.direction_url = RecipesService.shared.getDirectionUrl(atIndex: indexData)
            newFavorite.image_url = RecipesService.shared.getImageUrl(atIndex: indexData)
            newFavorite.order = Int32(order)
        }
    }

    // Re-organize the array when an element is moved from fromValue to toValue
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

    // Give to the element at index oldValue the value newValue
     static func updateIndex(oldValue: Int, newValue: Int) {
        let request: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "order = %d", oldValue)
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else {
            return
        }
        let recipeToUpdate = recipes[0] as NSManagedObject
        recipeToUpdate.setValue(newValue, forKey: "order")
        _ = CDRecipe.saveContext()
    }

    // Recalculate the index of all of the array following the order of the array
    static func recalculateIndex() {
        for (indexRecipe, recipe) in all.enumerated() {
            updateIndex(oldValue: Int(recipe.order), newValue: indexRecipe)
        }
    }
    
    // Delete a favorite with index from CoreData and send back false in case of error
    static func deleteFavorite(fromOrigin origin: OriginList, atIndex index: Int ) -> Bool {
        let request: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        let URL: String
        switch origin {
        case .favorite:
            URL = CDRecipe.getDirectionsUrl(atIndex: index)
        case .search:
            URL = RecipesService.shared.getDirectionUrl(atIndex: index)
        }
        request.predicate = NSPredicate(format: "direction_url = %@", URL)
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else {
            return false
        }
        let recipeToDelete = recipes[0] as NSManagedObject
        AppDelegate.viewContext.delete(recipeToDelete)
        return true
    }

    // Delete all the content of the DB. Function used only on testing
    static func resetAllRecords() {
        let entity = "CDRecipe"
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try AppDelegate.viewContext.execute(deleteRequest)
            try AppDelegate.viewContext.save()
        }
        catch
        {
            print("Error!")
        }
    }

    // Get the title of the requested recipe
    static func getTitle(atIndex index: Int) -> String {
        guard let title = CDRecipe.all[index].name else {
            return ""
        }
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

    // Get the order of a record at URL
    static func getOrder(atURL URL: String) -> Int {
        for recipe in CDRecipe.all where recipe.direction_url! == URL {
            return Int(recipe.order)
        }
        return 0
    }
}
