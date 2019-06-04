//
//  CDRecipeTest.swift
//  RecipleaseTests
//
//  Created by Nicolas Sommereijns on 04/06/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import XCTest
@testable import Reciplease

class CDRecipeTest: XCTestCase {

    // We reset the CoreData at each run
    override func setUp() {
        CDRecipe.resetAllRecords()
        RecipesService.shared.resetShared()
        UserIngredients.shared.resetIngredients()
        callARequest()
    }

    // We call the request only once if it wasn't called yet
    private func callARequest() {
        if RecipesService.shared.numberOfRecordsOnHit == 0 {
            let myExpectation = expectation(description: "requestWait")
            _ = UserIngredients.shared.addIngredient(toadd: "cheese")
            RecipesService.shared.requestRecipes() { (response) in
                guard response == .requestSuccessfull else {
                    print("Error!")
                    return
                }
                myExpectation.fulfill()
            }
            waitForExpectations(timeout: 20, handler: nil)
        }
    }

    // Adding a favorite at index Row
    private func addFavorite(fromRow row: Int) {
        RecipesService.shared.selectedRow = row
        CDRecipe.saveFavorite(fromOrigin: .search)
        CDRecipe.saveContext()
    }

    // Adding some favorites
    private func addSomeFavorites() -> [String] {
        var result = [String]()
        addFavorite(fromRow: 1)
        addFavorite(fromRow: 0)
        addFavorite(fromRow: 3)
        addFavorite(fromRow: 5)
        result.append(CDRecipe.getDirectionsUrl(atIndex: 0))
        result.append(CDRecipe.getDirectionsUrl(atIndex: 1))
        result.append(CDRecipe.getDirectionsUrl(atIndex: 2))
        result.append(CDRecipe.getDirectionsUrl(atIndex: 3))
        return result
    }
    
    // Testing add a new favorite
    func testGivenANewFavorite_WhenTesting_FavoriteIsSuccessfullySaved() {
        XCTAssertEqual(CDRecipe.numberOfRecords, 0)
        addFavorite(fromRow: 1)
        let originURL = RecipesService.shared.getDirectionUrl(atIndex: RecipesService.shared.selectedRow)
        XCTAssertEqual(CDRecipe.numberOfRecords, 1)
        XCTAssert(CDRecipe.recipeAlreadyAFavorite(withURL: originURL))
    }

    // Testing reordering. Original order is 0 - 1 - 2 - 3
    func testGivenSomeFavorites_WhenReorder_ReorderingShouldBeRespected() {
        let array = addSomeFavorites()
        CDRecipe.setNewOrder(fromValue: 2, toValue: 0)
        XCTAssertEqual(CDRecipe.getOrder(atURL: array[2]), 0)
        XCTAssertEqual(CDRecipe.getOrder(atURL: array[0]), 1)
        XCTAssertEqual(CDRecipe.getOrder(atURL: array[1]), 2)
        XCTAssertEqual(CDRecipe.getOrder(atURL: array[3]), 3)
        CDRecipe.setNewOrder(fromValue: 1, toValue: 3)
        XCTAssertEqual(CDRecipe.getOrder(atURL: array[2]), 0)
        XCTAssertEqual(CDRecipe.getOrder(atURL: array[1]), 1)
        XCTAssertEqual(CDRecipe.getOrder(atURL: array[3]), 2)
        XCTAssertEqual(CDRecipe.getOrder(atURL: array[0]), 3)
    }

    // Testing the delete of a record. Original order is 0 - 1 - 2 - 3 - 4
    func testGivenSomeFavorites_WhenDeleteAFavoriteAndReordering_OrderShouldStillBeCorrect() {
        let array = addSomeFavorites()
        XCTAssert(CDRecipe.deleteFavorite(fromOrigin: .favorite, atIndex: 2))
        CDRecipe.saveContext()
        CDRecipe.recalculateIndex()
        XCTAssertEqual(CDRecipe.getOrder(atURL: array[0]), 0)
        XCTAssertEqual(CDRecipe.getOrder(atURL: array[1]), 1)
        XCTAssertEqual(CDRecipe.getOrder(atURL: array[3]), 2)
        XCTAssertFalse(CDRecipe.recipeAlreadyAFavorite(withURL: array[2]))
    }

    func testGivenSomeFavorite_WhenAddingAndRestoreAFavorite_ThenFavoriteShouldBeRestored() {
        let array = addSomeFavorites()
        XCTAssert(CDRecipe.deleteFavorite(fromOrigin: .favorite, atIndex: 2))
        CDRecipe.saveFavorite(fromOrigin: .favorite)
        CDRecipe.saveContext()
        XCTAssertEqual(CDRecipe.numberOfRecords, array.count)
    }

    func testGivenSomeFavorites_WhenTestGetter_GetterShouldBeCorrect() {
        addFavorite(fromRow: 0)
        XCTAssertEqual(RecipesService.shared.getName(atIndex: 0), CDRecipe.getTitle(atIndex: 0))
        XCTAssertEqual(RecipesService.shared.getImageUrl(atIndex: 0), CDRecipe.getImageURL(atIndex: 0))
        XCTAssertEqual(RecipesService.shared.getIngredients(atIndex: 0), CDRecipe.getIngredients(atIndex: 0))
        XCTAssertEqual(RecipesService.shared.getFullIngredients(atIndex: 0), CDRecipe.getFullIngredients(atIndex: 0))
        XCTAssertEqual(RecipesService.shared.getDirectionUrl(atIndex: 0), CDRecipe.getDirectionsUrl(atIndex: 0))
        XCTAssertEqual(RecipesService.shared.getPreparationTime(atIndex: 0), CDRecipe.getPreparationTime(atIndex: 0))
    }

}
