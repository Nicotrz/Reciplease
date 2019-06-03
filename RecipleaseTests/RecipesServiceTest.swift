//
//  RecipesServiceTest.swift
//  RecipleaseTests
//
//  Created by Nicolas Sommereijns on 03/06/2019.
//  Copyright © 2019 Nicolas Sommereijns. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipesServiceTest: XCTestCase {

    override func setUp() {
        RecipesService.shared.resetShared()
        UserIngredients.shared.resetIngredients()
        super.setUp()
    }

    // When nothing is done yet, tooMuchTry should be false and number of hits should be at 0
    func testGivenAStartingPosition_WhenTestingTooMuchTryAndNumberOfHits_ResultShouldBeFalseAndZero() {
        XCTAssertFalse(RecipesService.shared.tooMuchTry)
        XCTAssertEqual(RecipesService.shared.numberOfRecordsOnHit, 0)
        XCTAssertEqual(RecipesService.shared.getName(atIndex: 1), "")
        XCTAssertEqual(RecipesService.shared.getPreparationTime(atIndex: 1), "")
        XCTAssertEqual(RecipesService.shared.getImageUrl(atIndex: 1), "")
        XCTAssertEqual(RecipesService.shared.getIngredients(atIndex: 1), "")
        XCTAssertEqual(RecipesService.shared.getFullIngredients(atIndex: 1), "")
        XCTAssertEqual(RecipesService.shared.getDirectionUrl(atIndex: 1), "")
    }

    // Testing call the server with invalid arguments 5 times in a row
    func testGivenAStartingPosition_WhenCallingTheRequestWithInvalidArguments_ResultShouldBeInvalidResponse() {
        for _ in 1...6 {
            let myExpectation = expectation(description: "invalidRequestWait")
            RecipesService.shared.requestRecipes() { (response) in
                myExpectation.fulfill()
            }
            waitForExpectations(timeout: 5, handler: nil)
        }
        XCTAssert(RecipesService.shared.tooMuchTry)
    }
    
    
    
    
    
    func testGivenAValidRequest_WhenCallingTheRequest_ResuldShouldBeValidResponse() {
        _ = UserIngredients.shared.addIngredient(toadd: "potato")
        RecipesService.shared.requestRecipes() { (response) in
            XCTAssertEqual(response, .requestSuccessfull)
            XCTAssertEqual(RecipesService.shared.numberOfRecordsOnHit, 9)
            RecipesService.shared.requestRecipes() { (secondResponse) in
                XCTAssertEqual(response, .requestSuccessfull)
                XCTAssertEqual(RecipesService.shared.numberOfRecordsOnHit, 18)
                XCTAssertNotNil(RecipesService.shared.getRecipes)
            }
        }
        RecipesService.shared.requestRecipes() { (response) in
            XCTAssertEqual(response, .networkError)
        }
    }
}
