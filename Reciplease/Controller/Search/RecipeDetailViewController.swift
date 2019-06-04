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
        let detail = RecipesService.shared.getFullIngredients(atIndex: indexData)
        let time = RecipesService.shared.getPreparationTime(atIndex: indexData)
        let directionURL = RecipesService.shared.getDirectionUrl(atIndex: indexData)
        let URLImage =  RecipesService.shared.getImageUrl(atIndex: indexData)
        setInterface(
            title: title, detail: detail, preparationTime: time, directionUrl: directionURL, imageURL: URLImage)
    }

    // Save a new favorite ( from Search interface)
    override func saveFavorite() {
        CDRecipe.saveFavorite(fromOrigin: .search)
    }

    // Delete the favorite ( from Search interface)
    override func deleteFavorite() {
        guard CDRecipe.deleteFavorite(fromOrigin: .search, atIndex: indexData) else {
            showAlertMessage(error: "an Unexpected error has occured!")
            return
        }
    }
}
