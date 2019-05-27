//
//  SearchResultViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 22/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultSearchCell", for: indexPath) as? ResultSearchTableViewCell else {
        return UITableViewCell()
        }
        let title = RecipesService.shared.getName(atIndex: indexPath.row)
        let ingredients = RecipesService.shared.getIngredients(atindex: indexPath.row)
        let preparationTime = RecipesService.shared.getPreparationTime(atIndex: indexPath.row)
        let imageUrl = RecipesService.shared.getImageUrl(atIndex: indexPath.row)
        cell.configure(title: title , detail: ingredients, preparationTime: preparationTime, imageUrl: imageUrl)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(RecipesService.shared.numberOfSearchResults)
        return RecipesService.shared.numberOfSearchResults
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RecipesService.shared.selectedRow = indexPath.row
        performSegue(withIdentifier: "loadDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
