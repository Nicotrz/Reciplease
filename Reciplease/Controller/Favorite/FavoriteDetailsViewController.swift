//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 27/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class FavoriteDetailsViewController: DetailViewController {
    
    // Get all of the informations from CD and send them to the interface
    override func loadData() {
        indexData = CDRecipe.selectedRow
        let title = CDRecipe.getTitle(atIndex: indexData)
        let detail = CDRecipe.getFullIngredients(atIndex: indexData)
        let time = CDRecipe.getPreparationTime(atIndex: indexData)
        let directionURL = CDRecipe.getDirectionsUrl(atIndex: indexData)
        let URLImage =  CDRecipe.getImageURL(atIndex: indexData)
        setInterface(
            title: title, detail: detail, preparationTime: time, directionUrl: directionURL, imageURL: URLImage)
    }

    // Saving the favorite from favorite source
    override func saveFavorite() {
        CDRecipe.saveFavorite(fromOrigin: .favorite)
    }

    // Delete the favorite from favorite source
    override func deleteFavorite() {
        CDRecipe.deleteFavorite(fromOrigin: .favorite, atIndex: indexData)
    }
}
