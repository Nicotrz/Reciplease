//
//  RecipeDetailViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 27/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var favIcon: UIBarButtonItem!
    @IBOutlet weak var illustrationImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: Private Properties
    
    // Favorite Property set automatically the associated image
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
    
    // The Direction URL serve as an ID
    var directionsURL = "http://www.google.com"

    // MARK: Public Properties:

    // To know the number of the selected row
    var indexData = 0
    
    // MARK: View Methods
    
    override func viewDidLoad() {
        refreshData()
        super.viewDidLoad()
    }
    // When the view will appear, we set the datas
    override func viewWillAppear(_ animated: Bool) {
        checkFavoriteStatus()
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        if CDRecipe.saveContext() {
            print("success!")
        }
    }

    // When the user leave the app, save current State
    override func encodeRestorableState(with coder: NSCoder) {
        AppDelegate.saveCurrentState(withCoder: coder)
        super.encodeRestorableState(with: coder)
    }
    
    // When the user come back to the app, restore current state
    override func decodeRestorableState(with coder: NSCoder) {
        AppDelegate.restoreCurrentState(withCoder: coder)
        super.decodeRestorableState(with: coder)
    }
    
    // MARK: Private Methods
    
    // This method will set all the page:
    // Favorite property & the other datas
    private func refreshData() {
        loadData()
        checkFavoriteStatus()
    }
    
    // Getting the favorite property from the CD Model with the URL Identifier
    // And use it to set the favorite property of the page
    func checkFavoriteStatus() {}
    
    // Get all of the informations and set them to the interface ( Override on Childs )
    func loadData() {}
    
    // Set the interface with the sended informations
    func setInterface(
        title: String, detail: String, preparationTime: String, directionUrl: String, imageURL: String) {
        titleLabel.text = title
        detailTextView.text = detail
        timeLabel.text = preparationTime
        directionsURL = directionUrl
        illustrationImage.imageFromServerURL(urlString: imageURL, placeHolderImage: UIImage.init())
    }
    
    // Trying to save the favorite from the model
    // In case of failure, show an alert message
    func saveFavorite() {}
    
    // Trying to delete the favorite from the model
    // In case of failure, show an alert message
    func deleteFavorite() {}
    
    // Show an error pop up with a "error" message
    func showAlertMessage(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    // The user press on the favorite buttoh
    @IBAction func makeFavorite(_ sender: Any) {
        favorite = !favorite
        if favorite {
            saveFavorite()
        } else {
            deleteFavorite()
        }
    }
    
    // The user press on the get direction button
    @IBAction func getDirection(_ sender: Any) {
        guard let url = URL(string: directionsURL) else { return }
        UIApplication.shared.open(url)
    }
}
