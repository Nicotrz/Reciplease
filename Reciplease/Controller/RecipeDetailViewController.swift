//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 27/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var illustrationImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        let recipe = RecipesService.shared.getRecipe(atindex: RecipesService.shared.selectedRow)
        titleLabel.text = recipe?.recipe?.label! ?? "default"
        detailTextView.text = RecipesService.shared.getFullIngredients(atindex: RecipesService.shared.selectedRow)
        illustrationImage.imageFromServerURL(urlString: recipe?.recipe?.image ?? "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png", PlaceHolderImage: UIImage.init() )
        super.viewWillAppear(animated)
    }
}
