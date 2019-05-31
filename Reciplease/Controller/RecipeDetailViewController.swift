//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 27/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    var favorite = false {
        didSet {
            let nameImage: String
            if favorite {
                nameImage = "favFull"
            } else {
                nameImage = "favEmpty"
            }
            favIcon.image = UIImage(imageLiteralResourceName: nameImage)
        }
    }
    
    var directionsURL = "http://www.google.com"
    
    @IBOutlet weak var favIcon: UIBarButtonItem!
    
    @IBOutlet weak var illustrationImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        switch AppDelegate.currentInterface {
        case .loading:
            loadDataFromRequest()
        case .favorite:
            loadDataFromCD()
        }
        checkFavoriteStatus()
        super.viewWillAppear(animated)
    }
    
    private func checkFavoriteStatus() {
        if CDRecipe.recipeAlreadyAFavorite(withURL: directionsURL) {
            favorite = true
        }
    }
    
    private func loadDataFromRequest() {
        let indexData = RecipesService.shared.selectedRow
        print("===================")
        print("Loading Data from Request")
        print("Selected row: \(indexData)")
        print("===================")
        let title = RecipesService.shared.getName(atIndex: indexData)
        let detail = RecipesService.shared.getFullIngredients(atindex: indexData)
        let time = RecipesService.shared.getPreparationTime(atIndex: indexData)
        let directionURL = RecipesService.shared.getDirectionUrl(atindex: indexData)
        let URLImage =  RecipesService.shared.getImageUrl(atIndex: indexData)
        setInterface(title: title, detail: detail, preparationTime: time, directionUrl: directionURL, imageURL: URLImage)
    }
    
    private func loadDataFromCD() {
        let index = CDRecipe.selectedRow
        print("===================")
        print("Loading Data from CD")
        print("Selected row: \(index)")
        print("===================")
        let title = CDRecipe.getTitle(atIndex: index)
        let detail = CDRecipe.getFullIngredients(atIndex: index)
        let time = CDRecipe.getPreparationTime(atIndex: index)
        let directionURL = CDRecipe.getDirectionsUrl(atIndex: index)
        let URLImage = CDRecipe.getImageURL(atIndex: index)
        setInterface(title: title, detail: detail, preparationTime: time, directionUrl: directionURL, imageURL: URLImage)
    }
    
    private func setInterface(title: String, detail: String, preparationTime: String, directionUrl: String, imageURL: String) {
        titleLabel.text = title
        detailTextView.text = detail
        timeLabel.text = preparationTime
        directionsURL = directionUrl
        illustrationImage.imageFromServerURL(urlString: imageURL, PlaceHolderImage: UIImage.init())
    }
    
    @IBAction func makeFavorite(_ sender: Any) {
        favorite = !favorite
        if favorite {
            saveFavorite()
        } else {
            deleteFavorite()
        }
    }
    
    @IBAction func getDirection(_ sender: Any) {
        guard let url = URL(string: directionsURL) else { return }
        UIApplication.shared.open(url)
    }
    
    private func saveFavorite() {
        if !CDRecipe.saveFavorite() {
            print ("erreur!")
        }
    }
    
    private func deleteFavorite() {
        if !CDRecipe.deleteFavorite(withURL: directionsURL) {
            print("erreur!")
        }
    }

    override func encodeRestorableState(with coder: NSCoder) {
        let toSave: Int
        switch AppDelegate.currentInterface {
        case .loading:
            toSave = RecipesService.shared.selectedRow
        case .favorite:
            toSave = CDRecipe.selectedRow
        }
        coder.encodeCInt(Int32(toSave), forKey: "SelectedRow")
        super.encodeRestorableState(with: coder)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        let restore = Int(coder.decodeInt32(forKey: "SelectedRow"))
        switch AppDelegate.currentInterface {
        case .loading:
            RecipesService.shared.selectedRow = restore
        case .favorite:
            CDRecipe.selectedRow = restore
        }
        super.decodeRestorableState(with: coder)
    }
}
