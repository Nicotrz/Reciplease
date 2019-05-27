//
//  SearchPageViewController.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 21/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import UIKit

class SearchPageViewController: UIViewController {

    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var ingredientListTextView: UITextView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        refreshList()
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadingActivityIndicator.isHidden = true
        super.viewWillAppear(animated)
    }
    @IBAction func addIngredient(_ sender: Any) {
        guard ingredientTextField.text != "" else {
            showAlertMessage(error: "Please type an ingredient first!")
            return
        }
        guard UserIngredients.shared.addIngredient(toadd: ingredientTextField.text!) else {
            showAlertMessage(error: "Please enter one ingredient at a time")
            return
        }
        ingredientTextField.text = ""
        refreshList()
    }

    @IBAction func clearList(_ sender: Any) {
        UserIngredients.shared.resetIngredients()
        refreshList()
    }

    @IBAction func searchRecipes(_ sender: Any) {
        guard !UserIngredients.shared.isEmpty else {
            showAlertMessage(error: "Please type an ingredient first!")
            return
        }
        loadingActivityIndicator.isHidden = false
        RecipesService.shared.requestRecipes() { (response) in
            guard response else {
                self.showAlertMessage(error: "Data loading error")
                return
            }
            self.performSegue(withIdentifier: "loadList", sender: nil)
        }
    }

    private func dismissKeyboard() {
        ingredientTextField.resignFirstResponder()
    }

    @IBAction func tapScreen(_ sender: Any) {
        dismissKeyboard()
    }

    private func refreshList() {
        ingredientListTextView.text = UserIngredients.shared.getIngredients()
    }

    private func showAlertMessage(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
