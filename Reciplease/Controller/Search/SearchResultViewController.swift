//
//  SearchResultViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 22/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

// MARK: View Controller
class SearchResultViewController: UIViewController {

    // MARK: Private properties

    // Are we currently fetching for more result ?
    private var fetchingMore = false

    // Can we fetch more result ?
    private var canFetchingMore = true

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: Override view methods

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
    }

    // If the user leave the app, we save the current state
    override func encodeRestorableState(with coder: NSCoder) {
        AppDelegate.saveCurrentState(withCoder: coder)
        super.encodeRestorableState(with: coder)
    }

    // If the user come back, we restore the current state
    override func decodeRestorableState(with coder: NSCoder) {
        AppDelegate.restoreCurrentState(withCoder: coder)
        super.decodeRestorableState(with: coder)
    }
}

// MARK: Table View
extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: Private methods

    // We warned the property we are currenty fetching
    // We reload the section to show the loading interface
    // Then we send the request
    // - In case of a successfull request => We do nothing
    // - In case of a network error, if the model tell us there already been too many try
    // we set canFetchingMore at false
    // - In case of a noResult, we set canFetchingMore at false
    // And finally, we reload the tableView
    private func beginBatchFetch() {
        fetchingMore = true
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            RecipesService.shared.requestRecipes { (response) in
                switch response {
                case .requestSuccessfull:
                    break
                case .networkError:
                    if RecipesService.shared.tooMuchTry {
                        self.canFetchingMore = false
                    }
                case .noResultFound:
                    self.canFetchingMore = false
                }
                self.fetchingMore = false
                self.tableView.reloadData()
            }
        }
    }

    // MARK: Protocols methods

    // We need 2 sections:
    // - One for the query results
    // - One for the loading cell
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    // Number of rows:
    // - If we are on the query, we send the number of hits as number of row
    // - If we are currently fetching for more result
    // and we are on the loading section, we send one row
    // Else ( not currently fetching ) -> No row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return RecipesService.shared.numberOfRecordsOnHit
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }

    // cellForRow:
    // If we are on the first section, we set all informations of the concerned hit
    // At the current row like a ResultSearchTableViewCell
    // Else, we just load a new LoadingCellTableViiewCell and activate the loading interface
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "ResultSearchCell", for: indexPath) as? ResultSearchTableViewCell else {
                    return UITableViewCell()
            }
            let title = RecipesService.shared.getName(atIndex: indexPath.row)
            let ingredients = RecipesService.shared.getIngredients(atindex: indexPath.row)
            let preparationTime = RecipesService.shared.getPreparationTime(atIndex: indexPath.row)
            let imageUrl = RecipesService.shared.getImageUrl(atIndex: indexPath.row)
            let directionUrl = RecipesService.shared.getDirectionUrl(atindex: indexPath.row)
            let favorite = CDRecipe.recipeAlreadyAFavorite(withURL: directionUrl)
            cell.configure(title: title, detail: ingredients, preparationTime: preparationTime, imageUrl: imageUrl, favorite: favorite)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "LoadingCell", for: indexPath) as? LoadingCellTableViewCell else {
                    return UITableViewCell()
            }
            cell.changeStatusLoadingInterface(activate: true)
            return cell
        }
    }
    
    // When the user select a row:
    // we send the selected row to the service
    // We perform the segue to detail
    // We deselect the row for when the user come back
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RecipesService.shared.selectedRow = indexPath.row
        performSegue(withIdentifier: "loadDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // The height of row differs:
    // If we are on the recipe cell, it is 180
    // If we are on the loading cell, it is 50
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 50
        } else {
            return 180
        }
    }

    // When the user scroll on the tableView:
    // If we can't fetch anymore, we do nothing
    // else, when the user approach the end of the tableView
    // If we are not already fetching
    // We begin to fetch
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard canFetchingMore else {
            return
        }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 3 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
}
