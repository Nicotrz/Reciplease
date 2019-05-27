//
//  SearchResultViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 22/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultSearchCell", for: indexPath) as? ResultSearchTableViewCell else {
        return UITableViewCell()
        }
        let recipe = RecipesService.shared.getRecipe(atindex: indexPath.row)
        cell.configure(title: recipe?.recipe?.label! ?? "default" , detail: recipe?.recipe.debugDescription ?? "default", like: "1", preparationTime: String(recipe!.recipe!.totalTime!) ?? "default")
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(RecipesService.shared.numberOfSearchResults)
        return RecipesService.shared.numberOfSearchResults
    }
}
