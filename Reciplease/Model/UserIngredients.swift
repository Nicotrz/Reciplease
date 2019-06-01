//
//  Ingredients.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 21/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import Foundation

// This object is a codable so it can be saved on UserDefault
class UserIngredients: Codable {

    // MARK: Public Properties
    
    // Singleton property
    static var shared = UserIngredients()

    // Array with all of the ingredients
    var all = [String]()

    // Is the array empty ?
    var isEmpty: Bool {
        return all.isEmpty
    }

    // MARK: Private methods

    // Private init for singleton
    private init() {}

    // MARK: Public Methods

    // Add a new ingredient to the array
    // Only if it doesnt contain a special character
    func addIngredient(toadd ingredients: String ) -> Bool {
        guard !ingredients.containsSpecialCharacter else {
            return false
        }
        all.append(ingredients)
        return true
    }

    // Get all of the ingredients on a pretty string
    func getIngredients() -> String {
        var result = ""
        guard !all.isEmpty else {
            return result
        }

        for ingredient in all {
            result += "- \(ingredient)\n"
        }
        return result
    }

    // Reset all of the object (delete everything)
    func resetIngredients() {
        all = [String]()
    }

}
