//
//  FavoriteListViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 29/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        RecipesService.shared.doesUserLoadData = false
        super.viewWillAppear(animated)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultSearchCell", for: indexPath) as? ResultSearchTableViewCell else {
                return UITableViewCell()
            }
            let title = CDRecipe.getTitle(atIndex: indexPath.row)
            let ingredients = CDRecipe.getIngredients(atIndex: indexPath.row)
            let preparationTime = CDRecipe.getPreparationTime(atIndex: indexPath.row)
            let imageUrl = CDRecipe.getImageURL(atIndex: indexPath.row)
            cell.configure(title: title , detail: ingredients, preparationTime: preparationTime, imageUrl: imageUrl)
            return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CDRecipe.numberOfRecords
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CDRecipe.selectedRow = indexPath.row
        performSegue(withIdentifier: "loadDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 0
        return 180
    }
}
