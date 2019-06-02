//
//  FavoriteListViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 29/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var noFavoriteView: UIView!

    private var noFavoriteYet: Bool = true {
        didSet {
            noFavoriteView.isHidden = !noFavoriteYet
            editButton.isEnabled = !noFavoriteYet
        }
    }
    
    // MARK: View Methods

    // When the view will appear, we refresh the array
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        checkNumberOfFavorites()
        super.viewWillAppear(animated)
    }

    // When user is leaving, we save the current state of the app
    override func encodeRestorableState(with coder: NSCoder) {
        AppDelegate.saveCurrentState(withCoder: coder)
        super.encodeRestorableState(with: coder)
    }

    // When the user is back, we restore the current state of the app
    override func decodeRestorableState(with coder: NSCoder) {
        AppDelegate.restoreCurrentState(withCoder: coder)
        super.decodeRestorableState(with: coder)
    }

    // MARK: Action

    @IBAction func selectEdit(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }
    }

    private func checkNumberOfFavorites() {
        if CDRecipe.numberOfRecords == 0 {
            noFavoriteYet = true
        } else {
            noFavoriteYet = false
        }
    }
}

extension FavoriteListViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: Table View methods

    // Only one section on this tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // The number of row is the number of records on CD
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CDRecipe.numberOfRecords
    }

    // CellForRow:
    // We show the cell as a ResultSearchCell
    // We request Data from the CD Model
    // And use it to configure the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ResultSearchCell", for: indexPath) as? ResultSearchTableViewCell else {
                return UITableViewCell()
        }
        let title = CDRecipe.getTitle(atIndex: indexPath.row)
        let ingredients = CDRecipe.getIngredients(atIndex: indexPath.row)
        let preparationTime = CDRecipe.getPreparationTime(atIndex: indexPath.row)
        let imageUrl = CDRecipe.getImageURL(atIndex: indexPath.row)
        cell.configure(title: title, detail: ingredients, preparationTime: preparationTime, imageUrl: imageUrl, favorite: false)
        return cell
    }

    // When the user load the data, we save the selected row
    // And send the user to the detail view
    // Then we deselect the row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CDRecipe.selectedRow = indexPath.row
        performSegue(withIdentifier: "loadDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // If the user swipe to delete the row, we call the delete function
    // With the URL argument
    func tableView(
        _ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CDRecipe.deleteFavorite(fromOrigin: .favorite, atIndex: indexPath.row)
            if CDRecipe.saveContext() {
                CDRecipe.recalculateIndex()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                checkNumberOfFavorites()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("==================")
        print("CALLING MOVING)")
        print("From \(sourceIndexPath.row) - To: \(destinationIndexPath.row)")
        print("==================")
        CDRecipe.setNewOrder(fromValue: sourceIndexPath.row, toValue: destinationIndexPath.row)
    }
    
}
