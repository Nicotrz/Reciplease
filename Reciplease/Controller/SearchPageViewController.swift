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
        Ingredients.shared.addIngredient(toadd: ingredientTextField.text!)
        ingredientTextField.text = ""
        refreshList()
    }

    @IBAction func clearList(_ sender: Any) {
        Ingredients.shared.resetIngredients()
        refreshList()
    }

    @IBAction func searchRecipes(_ sender: Any) {
        RecipesService.shared.requestRecipes { (error, _) in
            switch error {
            case .decodableInvalid:
                print("Je sais pas décoder")
            case .networkError:
                print("je sais pas aller chercher le fichier")
            case .responseInvalid:
                print("La réponse n'est pas bonne")
            case .requestSuccessfull:
                print("ah bah ca fonctionne finalement")
            }
        }
    }

    private func dismissKeyboard() {
        ingredientTextField.resignFirstResponder()
    }

    @IBAction func tapScreen(_ sender: Any) {
        dismissKeyboard()
    }

    private func refreshList() {
        ingredientListTextView.text = Ingredients.shared.getIngredients()
    }

    private func showAlertMessage(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
