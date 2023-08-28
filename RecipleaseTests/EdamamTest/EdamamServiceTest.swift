//
//  EdamamServiceTest.swift
//  RecipleaseTests
//
//  Created by Giovanni Gabriel on 25/07/2023.
//

import XCTest
import Mocker
import Alamofire
@testable import Reciplease

class EdamamServiceTests: XCTestCase {
    
    private var edamamService: EdamamService!
    let originalURL = URL(string: EdamamURL.endpoint)!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        edamamService = EdamamService(edamamSession: sessionManager)
    
    }
    
    override func tearDown() {
        super.tearDown()
        Mocker.removeAll()
    }
    
    func testGetRecipeWithValidIngradients() {
//        Given
        
//        When
//        Then
            }

    func testGetRecipeWithEmptyIngredients() {
        // Given
        let ingredients: [String] = []
        
        let getRecipesExpectation = self.expectation(description: "getRecipes")
        var successResult: Bool?
        var responseResult: Recipes?
        var errorResult: Error?
        
        // When
        edamamService.getRecipes(for: ingredients) { success, response in
            successResult = success
            responseResult = response
            getRecipesExpectation.fulfill()
        }
        
        wait(for: [getRecipesExpectation], timeout: 1.0)
        
        // Then
        XCTAssertFalse(successResult ?? true, "Request should fail with empty ingredients.")
        XCTAssertNil(responseResult, "Response should be nil.")
        XCTAssertNil(errorResult, "Error should be nil.")
        
        // Clean up (if applicable)
    }
}
