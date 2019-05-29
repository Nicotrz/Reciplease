//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 27/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit
import CoreData

class RecipeDetailViewController: UIViewController {

    var favorite = false

    var directionsURL = "http://www.google.com"
    
    @IBOutlet weak var favIcon: UIBarButtonItem!
    
    @IBOutlet weak var illustrationImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        super.viewWillAppear(animated)
    }
    
    private func loadData() {
        let indexData = RecipesService.shared.selectedRow
        titleLabel.text = RecipesService.shared.getName(atIndex: indexData)
        detailTextView.text = RecipesService.shared.getFullIngredients(atindex: indexData)
        timeLabel.text = RecipesService.shared.getPreparationTime(atIndex: indexData)
        directionsURL = RecipesService.shared.getDirectionUrl(atindex: indexData)
        illustrationImage.imageFromServerURL(urlString: RecipesService.shared.getImageUrl(atIndex: indexData), PlaceHolderImage: UIImage.init())
    }

    private func changeImageStatus() {
        if favorite {
            favIcon.image = UIImage(imageLiteralResourceName: "favEmpty")
        } else {
            favIcon.image = UIImage(imageLiteralResourceName: "favFull")
        }
    }

    @IBAction func makeFavorite(_ sender: Any) {
        changeImageStatus()
        favorite = !favorite
        if favorite {
            saveFavorite()
        }
    }

    @IBAction func getDirection(_ sender: Any) {
        guard let url = URL(string: directionsURL) else { return }
        UIApplication.shared.open(url)
    }

    private func saveFavorite() {
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
            print("success!")
        }
        catch {
            print("Failed!")
        }
    }
}
