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
    
    private static var all: [CDRecipe] {
        let request: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        guard let recipes = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return recipes
    }

    static var numberOfRecords: Int {
        return CDRecipe.all.count
    }

    static func recipeAlreadyAFavorite(withURL url: String) -> Bool {
        for recipe in CDRecipe.all where recipe.direction_url! == url {
            return true
        }
        return false
    }

    static func saveFavorite() -> Bool {
        let newFavorite = CDRecipe(context: AppDelegate.viewContext)
        let indexData = RecipesService.shared.selectedRow
        newFavorite.name = RecipesService.shared.getName(atIndex: indexData)
        newFavorite.ingredients_detail = RecipesService.shared.getFullIngredients(atindex: indexData)
        newFavorite.ingredients_list = RecipesService.shared.getIngredients(atindex: indexData)
        newFavorite.preparation_time = RecipesService.shared.getPreparationTime(atIndex: indexData)
        newFavorite.direction_url = RecipesService.shared.getDirectionUrl(atindex: indexData)
        newFavorite.image_url = RecipesService.shared.getImageUrl(atIndex: indexData)
        do {
            try AppDelegate.viewContext.save()
            return true
        }
        catch {
            return false
        }
    }

    static func deleteFavorite(withURL URL: String ) -> Bool {
    let request: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
    request.predicate = NSPredicate(format: "direction_url = %@", URL)
    guard let recipes = try? AppDelegate.viewContext.fetch(request) else {
    return false
    }
    let recipeToDelete = recipes[0] as NSManagedObject
    AppDelegate.viewContext.delete(recipeToDelete)
        do {
            try AppDelegate.viewContext.save()
            return true
        }
        catch {
            return false
        }
}

    static func getTitle(atIndex index: Int) -> String {
        guard let title = CDRecipe.all[index].name else {
            return ""
        }
        return title
    }

    static func getIngredients(atIndex index: Int) -> String {
        guard let ingredients = CDRecipe.all[index].ingredients_list else {
            return ""
        }
        return ingredients
    }

    static func getFullIngredients(atIndex index: Int) -> String {
        guard let ingredients = CDRecipe.all[index].ingredients_detail else {
            return ""
        }
        return ingredients
    }

    static func getImageURL(atIndex index: Int) -> String {
        guard let imageURL = CDRecipe.all[index].image_url else {
            return ""
        }
        return imageURL
    }

    static func getDirectionsUrl(atIndex index: Int) -> String {
        guard let directionsURL = CDRecipe.all[index].direction_url else {
            return ""
        }
        return directionsURL
    }

    static func getPreparationTime(atIndex index: Int) -> String {
        guard let preparationTime = CDRecipe.all[index].preparation_time else {
            return ""
        }
        return preparationTime
    }
}
