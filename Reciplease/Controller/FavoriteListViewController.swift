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
        super.viewWillAppear(animated)
        tableView.reloadData()
        RecipesService.shared.doesUserLoadData = false
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultSearchCell", for: indexPath) as? ResultSearchTableViewCell else {
                return UITableViewCell()
            }
            let title = CDRecipe.all[indexPath.row].name!
            let ingredients = CDRecipe.all[indexPath.row].ingredients_list!
            let preparationTime = CDRecipe.all[indexPath.row].preparation_time!
            let imageUrl = CDRecipe.all[indexPath.row].image_url!
            cell.configure(title: title , detail: ingredients, preparationTime: preparationTime, imageUrl: imageUrl)
            return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CDRecipe.all.count
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
