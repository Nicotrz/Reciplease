//
//  SearchPageViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 21/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class SearchPageViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var ingredientListTextView: UITextView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    // MARK: Override View methods

    // When the View will appear, make disappear the loading interface
    // Reset the RecipesService
    // And show the refreshed list of user ingredients

    override func viewWillAppear(_ animated: Bool) {
        setLoadingInterface(activate: false)
        RecipesService.shared.resetShared()
        refreshList()
        super.viewWillAppear(animated)
    }

    // If the user leave the app, save the current state
    override func encodeRestorableState(with coder: NSCoder) {
        AppDelegate.saveCurrentState(withCoder: coder)
        super.encodeRestorableState(with: coder)
    }

    // If the user come back on the app, restore the current state
    override func decodeRestorableState(with coder: NSCoder) {
        AppDelegate.restoreCurrentState(withCoder: coder)
        super.decodeRestorableState(with: coder)
    }

    // MARK: Private methods

    // Get the list of user ingredients and show it on the textView
    private func refreshList() {
        ingredientListTextView.text = UserIngredients.shared.getIngredients()
    }

    // Show an error pop up with a "error" message
    private func showAlertMessage(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // (des)activate the loading interface
    private func setLoadingInterface(activate: Bool) {
        loadingActivityIndicator.isHidden = !activate
        addButton.isEnabled = !activate
        searchButton.isEnabled = !activate
        clearButton.isEnabled = !activate
        ingredientTextField.isEnabled = !activate
    }

    // Dismiss the keyboard
    private func dismissKeyboard() {
        ingredientTextField.resignFirstResponder()
    }

    // MARK: Actions

    // When the user pressed "Add ingredients"
    // - Checking if the text field is filled
    // - Checking if the text field does not contain any special character
    // If everything is ok => send it to the shared object, reset text field and refresh the list
    @IBAction func addIngredient(_ sender: Any) {
        guard ingredientTextField.text != "" && ingredientTextField.text != nil else {
            showAlertMessage(error: "Please type an ingredient first!")
            return
        }
        guard UserIngredients.shared.addIngredient(toadd: ingredientTextField.text!) else {
            showAlertMessage(error: "The text shouldn't contain any special character")
            return
        }
        ingredientTextField.text = ""
        refreshList()
    }

    // When the user pressed "Clear the list"
    // Reset the list and refresh the text viewx
    @IBAction func clearList(_ sender: Any) {
        UserIngredients.shared.resetIngredients()
        refreshList()
    }

    // When the user pressed "Search for recipes"
    // We check we have at least one ingredient
    // If we do, we activate the loading interface
    // And send the request to the model
    // Then we check the answer, and react differently
    // Following the result
    @IBAction func searchRecipes(_ sender: Any) {
        guard !UserIngredients.shared.isEmpty else {
            showAlertMessage(error: "Please type an ingredient first!")
            return
        }
        setLoadingInterface(activate: true)
        RecipesService.shared.requestRecipes { (response) in
            switch response {
            case .requestSuccessfull:
                self.performSegue(withIdentifier: "loadList", sender: nil)
            case .networkError:
                self.showAlertMessage(error: "Data loading error")
            case .noResultFound:
                self.showAlertMessage(error: "No result found")
            }
            self.setLoadingInterface(activate: false)
        }
    }
    
    // When the user press anywhere on the screen, we dismiss the keyboard
    @IBAction func tapScreen(_ sender: Any) {
        dismissKeyboard()
    }
    
    
}
