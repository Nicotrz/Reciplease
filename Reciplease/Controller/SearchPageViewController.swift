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

    override func viewDidLoad() {
        refreshList()
        super.viewDidLoad()
    }

    @IBAction func addIngredient(_ sender: Any) {
        guard ingredientTextField.text != "" else {
            showAlertMessage(error: "Please type an ingredient first!")
            return
        }
        UserIngredients.shared.addIngredient(toadd: ingredientTextField.text!)
        ingredientTextField.text = ""
        refreshList()
    }

    @IBAction func clearList(_ sender: Any) {
        UserIngredients.shared.resetIngredients()
        refreshList()
    }

    @IBAction func searchRecipes(_ sender: Any) {
        RecipesService.shared.requestRecipes()
        performSegue(withIdentifier: "loadList", sender: nil)
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
