//
//  RecipesService.swift
//  Reciplease
//
//  Created by Nicolas Sommereijns on 24/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import Foundation
import Alamofire

class RecipesService {

    // MARK: Enumeration

    // Different result who can be sended by the request
    enum ErrorCase {
        case requestSuccessfull
        case networkError
        case noResultFound
    }

    // MARK: Private Properties

    // Singleton Property
    static var shared = RecipesService()

    // Index to build the request (from recipe indexFrom to recipe indexTo)
    private var indexFrom = 0
    private var indexTo = -1

    // The URL for the request
    private var requestURL = "https://api.edamam.com/search"

    // Is a fetch already in progress ?
    private var isFetchInProgress = false

    // Session for AlamoFire
    private let session = Alamofire.Session()

    // Number of try on the same request
    private var numberOfTry = 0

    // The recipes object to collect all of the recipes
    private var recipes: Recipes?

    // Retrieve the appKey and AppID from the keys.plist file
    // Please note: the software cannot work without it
    private var appKey: String {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
            return ""
        }
        let keys = NSDictionary(contentsOfFile: path)
        guard let dict = keys else {
            return ""
        }
        guard let resultKey = dict["app_key"] as? String else {
            return ""
        }
        print("app key: \(resultKey)")
        return resultKey
    }
    
    private var appId: String {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
            return ""
        }
        let keys = NSDictionary(contentsOfFile: path)
        guard let dict = keys else {
            return ""
        }
        guard let resultKey = dict["app_id"] as? String else {
            return ""
        }
        print("app id: \(resultKey)")
        return resultKey
    }

    // MARK: Init methods

    // Init private for Singleton
    private init() {}

    // MARK: public properties

    // Current Selected row on the table view
    var selectedRow = 0

    // If we tried already 5 times the same request, we stop trying
    var tooMuchTry: Bool {
        if numberOfTry >= 5 {
            return true
        } else {
            return false
        }
    }
    
    // Number of records currently on hit ( 0 if one of the object is nil )
    var numberOfRecordsOnHit: Int {
        return recipes?.hits?.count ?? 0
    }

    // MARK: Private methods

    // Creating the request from the URL with appId, appKey, indexFrom and indexTo
    private func createRecipeRequest(withRequest request: String ) -> String {
        return "\(requestURL)?app_id=\(appId)&app_key=\(appKey)&q=\(request)&from=\(indexFrom)&to=\(indexTo)"
    }

    // Method do calculate a new From and a new To
    private func recalculateFromTo() {
        indexFrom = indexTo + 1
        indexTo = indexFrom + 9
    }

    // Get the recipe from a precise index of the Hit array ( or nil if not found )
    private func getRecipe(atIndex index: Int) -> Recipe? {
        return recipes?.hits?[index].recipe ?? nil
    }

    // Create a request from the UserIngredients array
    private func createRequestDetail() -> String {
        var result = ""
        for ingredient in UserIngredients.shared.all {
            let readyForRequest = getTextReadyForRequest(textToTranslate: ingredient)
            result += "%20\(readyForRequest)"
        }
        return result
    }

    // This function translate the text in a version suitable for an URL Query
    // ( example: space are replaced by %20 )
    private func getTextReadyForRequest(textToTranslate: String) -> String {
        let resultToSend: String = textToTranslate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return resultToSend
    }

    // MARK: Public methods

    // Reset the object
    func resetShared() {
        RecipesService.shared = RecipesService()
    }
    
    // Get the name of the recipe at a precise index
    func getName(atIndex index: Int) -> String {
        guard let recipe = getRecipe(atIndex: index) else {
            return ""
        }
        guard let label = recipe.label else {
            return ""
        }
        return label
    }

    // Get the preparation time of the recipe at a precise index
    func getPreparationTime(atIndex index: Int) -> String {
        guard let recipe = getRecipe(atIndex: index) else {
            return ""
        }
        guard let preparationTime = recipe.totalTime else {
            return "-"
        }
        guard preparationTime != 0 else {
            return "-"
        }
        return "\(String(preparationTime))'"
    }

    // Get the URL of illustration at a precise index
    func getImageUrl(atIndex index: Int) -> String {
        guard let recipe = getRecipe(atIndex: index) else {
            return ""
            }
        guard let url = recipe.image else {
            return ""
        }
        return url
    }

    // Get ingredients for horizontal list at a precise index
    func getIngredients(atIndex index: Int) -> String {
        guard let recipe = getRecipe(atIndex: index) else {
            return ""
        }
        var result = ""
        guard let ingredientLines = recipe.ingredientLines else {
            return ""
        }
        for ingredient in ingredientLines {
            result += "\(ingredient), "
        }
        return result
    }

    // Get ingredients as a vertical list at a precise index
    func getFullIngredients(atIndex index: Int) -> String {
        guard let recipe = getRecipe(atIndex: index) else {
            return ""
        }
        guard let ingredients = recipe.ingredients else {
            return ""
        }
        var result = ""
        for ingredient in ingredients {
            guard let text = ingredient.text else {
                return result
            }
            result += "- \(text)\n"
        }
        return result
    }

    // Get the direction URL at a precise index
    func getDirectionUrl(atIndex index: Int) -> String {
        guard let recipe = getRecipe(atIndex: index) else {
            return ""
            }
        guard let url = recipe.url else {
            return ""
        }
        return url
    }

    // Get the From and To like an array of Int
    func getFromAndTo() -> [Int] {
        return [indexFrom, indexTo]
    }


    // Set the from and to
    func setFromAndTo(from indexFrom: Int, to indexTo: Int) {
        self.indexFrom = indexFrom
        self.indexTo = indexTo
    }
    
    // Request the recipes. We need a closure on argument with:
    // - Type of error for result purpose
    // This method send the result to the recipes variable
    func requestRecipes(callback: @escaping (ErrorCase) -> Void) {
        print("==============")
        print(numberOfTry)
        print("==============")
        // Checking that we are not already retrieving data
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        numberOfTry += 1
        // Create the request
        let request = createRequestDetail()
        recalculateFromTo()
        let url = createRecipeRequest(withRequest: request)
        // Set up the call and fire it off
        session.request(url).responseDecodable { (response: DataResponse<Recipes>) in
            self.isFetchInProgress = false
            switch response.result {
            case let .success(value):
                // If we didn't set the result yet, create the recipe object
                if self.recipes == nil {
                    self.recipes = value
                } else {
                    // We safely unwrapped the hits, and add them to the already existing array of hit
                    guard var originHits = self.recipes!.hits else {
                        callback(.networkError)
                        return
                    }
                    guard let newHits = value.hits else {
                        callback(.networkError)
                        return
                    }
                    originHits.append(contentsOf: newHits)
                    // We can uncast recipes with ! since we checked above it wasn't nil
                    self.recipes!.hits = originHits
                }
                // Checking we have at least one result
                guard value.count ?? 0 > 0 else {
                    callback(.noResultFound)
                    return
                }
                // Everything is fine. The request was successfull
                callback(.requestSuccessfull)
                print("success!")
                self.numberOfTry = 0
            case .failure(_):
                // Fail. Sending back networkError and increment numberOfTry
                callback(.networkError)
            }
        }
    }

    // Get the full recipes object
    func getRecipes() -> Recipes? {
        return recipes
    }

    // Replace the full recipes object
    func setRecipes(withRecipes recipes: Recipes) {
        self.recipes = recipes
    }
}
