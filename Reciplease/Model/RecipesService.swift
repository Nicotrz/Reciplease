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

    enum ErrorCase {
        case requestSuccessfull
        case networkError
        case noResultFound
    }

    var from = 0
    var to = -1
    
    // MARK: Singleton Property
    static var shared = RecipesService()
    
    // MARK: Init methods

    // Init private for Singleton
    private init() {}

    // MARK: private properties

    // The URL for the request
    private var requestURL = "https://api.edamam.com/search"

    private var isFetchInProgress = false
    
    var doesUserLoadData = true
    
    var selectedRow = 0
    
    let session = Alamofire.Session()

    // The Rate object to collect current rates
    private var recipes: Recipes?

    // Retrieve the accessKey from the keys.plist file
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

    var numberOfSearchResults: Int {
        return recipes?.hits?.count ?? 0
    }
    
    // MARK: Private methods

    // Creating the request from the URL with accessKey
    private func createRecipeRequest(withRequest request: String ) -> String {
        return "\(requestURL)?app_id=\(appId)&app_key=\(appKey)&q=\(request)&from=\(from)&to=\(to)"
    }

    // MARK: Public methods

    // Reset the object
    func resetShared() {
        RecipesService.shared = RecipesService()
    }

    private func recalculateFromTo() {
        from = to + 1
        to = from + 9
    }

    private func getRecipe(atIndex index: Int) -> Recipe? {
        guard let unwrappedReciped = recipes else {
            return nil
        }
        guard let unwrappedHit = unwrappedReciped.hits else {
            return nil
        }
        guard let unwrappedRecipe = unwrappedHit[index].recipe else {
            return nil
        }
        return unwrappedRecipe
    }

    func getName(atIndex index: Int) -> String {
        guard let recipe = getRecipe(atIndex: index) else {
            return ""
        }
        guard let label = recipe.label else {
            return ""
        }
        return label
    }

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

    func getImageUrl(atIndex index: Int) -> String {
        guard let recipe = getRecipe(atIndex: index) else {
            return ""
            }
        guard let url = recipe.image else {
            return ""
        }
        return url
    }

    func getIngredients(atindex index: Int) -> String {
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

    func getFullIngredients(atindex index: Int) -> String {
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

    func getDirectionUrl(atindex index: Int) -> String {
        guard let recipe = getRecipe(atIndex: index) else {
            return ""
            }
        guard let url = recipe.url else {
            return ""
        }
        return url
    }

    private func createRequestDetail() -> String {
        var result = ""
        for ingredient in UserIngredients.shared.all {
            result += "%20\(ingredient)"
        }
        return result
    }

    // Refresh the ChangeRate. We need a closure on argument with:
    // - Type of error for result purpose
    // - String? contain the update date on european format
    // This method send the result to the rates variable
    func requestRecipes(callback: @escaping (ErrorCase) -> Void)
    {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        let request = createRequestDetail()
        recalculateFromTo()
        let url = createRecipeRequest(withRequest: request)
        // Set up the call and fire it off
        session.request(url).responseDecodable() { (response: DataResponse<Recipes>) in
            self.isFetchInProgress = false
            switch response.result {
            case let .success(value):
                if self.recipes == nil {
                    self.recipes = value
                } else {
                    guard var originHits = self.recipes!.hits else {
                        callback(.networkError)
                        return
                    }
                    guard let newHits = value.hits else {
                        callback(.networkError)
                        return
                    }
                    originHits.append(contentsOf: newHits)
                    self.recipes!.hits = originHits
                }
                guard value.count ?? 0 > 0 else {
                    callback(.noResultFound)
                    return
                }
                callback(.requestSuccessfull)
            case let .failure(error):
                print("==========")
                print(error)
                print("==========")
                callback(.networkError)
            }
        }
    }
}
