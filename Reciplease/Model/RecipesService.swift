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

    // Differents return of ErrorCase possibles
    enum ErrorCase {
        case requestSuccessfull
        case responseInvalid
        case decodableInvalid
        case networkError
    }

    // MARK: Singleton Property
    static var shared = RecipesService()

    // MARK: Init methods

    // Init private for Singleton
    private init() {}

    // init for testing purposes
    init(recipesSession: URLSession) {
        self.recipesSession = recipesSession
    }

    // MARK: private properties

    // The URL for the request
    private var requestURL = "https://api.edamam.com/search"

    // The task for the request
    private var task: URLSessionDataTask?

    // The session for the request
    private var recipesSession = URLSession(configuration: .default)

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

    // MARK: Private methods

    // Creating the request from the URL with accessKey
    private func createRecipeRequest(withRequest request: String) -> String {
        return "\(requestURL)?app_id=\(appId)&app_key=\(appKey)&q=\(request)"
    }

    // MARK: Public methods

    // Reset the object
    func resetShared() {
        RecipesService.shared = RecipesService()
    }

    // Refresh the ChangeRate. We need a closure on argument with:
    // - Type of error for result purpose
    // - String? contain the update date on european format
    // This method send the result to the rates variable
    func requestRecipes(callback: @escaping (ErrorCase, String?) -> Void) {
        let request = createRecipeRequest(withRequest: "apple")
    }
}
