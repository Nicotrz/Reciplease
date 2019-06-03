//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Nicolas Sommereijns on 21/05/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import XCTest
@testable import Reciplease

class UserIngredientsTests: XCTestCase {

    override func setUp() {
        UserIngredients.shared.resetIngredients()
        super.setUp()
    }

    // When adding a new ingredient, if it has special character, the ingredient should not be added and the result of the method is false
    func testGivenAnEmptyArray_WhenAddingIngredientWithSpecialCharacter_ThenMethodShouldReturnFalseAndIngredientShouldNotBeAdded() {
        let result = UserIngredients.shared.addIngredient(toadd: "potato;")
        XCTAssertFalse(result)
        XCTAssertEqual(UserIngredients.shared.isEmpty, true)
        
    }
    
    // When adding a new ingredient, if it has not a special characxter, the ingredient should be added and the result of the method is true
    func testGivenAnEmptyArray_WhenAddingIngredientWithoutSpecialCharacter_ThenMethodSouldReturnTrueAndIngredientShouldBeAdded() {
        let result = UserIngredients.shared.addIngredient(toadd: "potato")
        XCTAssert(result)
        let firstElement = UserIngredients.shared.all[0]
        XCTAssertEqual(firstElement, "potato")
    }
    
    // When we call getIngredients, we have what's in the array in a pretty form
    func testGivenAnEmptyArray_WhenAddingIngredientsWithoutSpecialCharacterAndCallingGetIngredients_ThenMethodShouldReturnAPrettyString() {
        XCTAssertEqual(UserIngredients.shared.getIngredients(), "")
        _ = UserIngredients.shared.addIngredient(toadd: "potato")
        XCTAssertEqual(UserIngredients.shared.getIngredients(), "- potato\n")
    }
}
