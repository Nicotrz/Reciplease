//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 27/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    var favorite = false
    
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
    }

}
