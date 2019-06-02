//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 27/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class RecipeDetailViewController: DetailViewController {

    // Get all of the informations from the Request and send them to the interface
    override func loadData() {
        indexData = RecipesService.shared.selectedRow
        let title = RecipesService.shared.getName(atIndex: indexData)
        let detail = RecipesService.shared.getFullIngredients(atindex: indexData)
        let time = RecipesService.shared.getPreparationTime(atIndex: indexData)
        let directionURL = RecipesService.shared.getDirectionUrl(atindex: indexData)
        let URLImage =  RecipesService.shared.getImageUrl(atIndex: indexData)
        setInterface(
            title: title, detail: detail, preparationTime: time, directionUrl: directionURL, imageURL: URLImage)
    }

    override func saveFavorite() {
        favIcon.isEnabled = false
        CDRecipe.saveFavorite(fromOrigin: .search)
    }

    override func deleteFavorite() {
        CDRecipe.deleteFavorite(atIndex: indexData)
    }

    override func checkFavoriteStatus() {
        if CDRecipe.recipeAlreadyAFavorite(fromOrigin: .search, fromIndex: indexData) {
            favorite = true
            favIcon.isEnabled = false
        } else {
            favorite = false
            favIcon.isEnabled = true
        }
    }

}
