//
//  Ingredients.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 21/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import Foundation

class UserIngredients {

    static var shared = UserIngredients()

    var all = [String]()

    private init() {}

    func addIngredient(toadd ingredients: String ) {
        all.append(ingredients)
    }

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

    func resetIngredients() {
        all = [String]()
    }
}
