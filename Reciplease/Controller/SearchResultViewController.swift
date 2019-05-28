//
//  SearchResultViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 22/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var fetchingMore = false
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultSearchCell", for: indexPath) as? ResultSearchTableViewCell else {
        return UITableViewCell()
        }
        let title = RecipesService.shared.getName(atIndex: indexPath.row)
        let ingredients = RecipesService.shared.getIngredients(atindex: indexPath.row)
        let preparationTime = RecipesService.shared.getPreparationTime(atIndex: indexPath.row)
        let imageUrl = RecipesService.shared.getImageUrl(atIndex: indexPath.row)
            cell.configure(title: title , detail: ingredients, preparationTime: preparationTime, imageUrl: imageUrl)
        return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCellTableViewCell else {
                return UITableViewCell()
            }
            cell.changeStatusLoadingInterface(activate: true)
            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return RecipesService.shared.numberOfSearchResults
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RecipesService.shared.selectedRow = indexPath.row
        performSegue(withIdentifier: "loadDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 0
        if indexPath.section == 1 {
            return 50
        } else {
            return 180
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        RecipesService.shared.requestRecipes() { (response) in
            switch response {
            case .requestSuccessfull:
                print("success!")
            case .networkError:
                print("network error")
            case .noResultFound:
                print("no result")
            }
            self.fetchingMore = false
            self.tableView.reloadData()
        }
        }
    }
}
