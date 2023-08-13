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
    
        let manager: Session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockingURLProtocol.self]
                return configuration
            }()
            return Session(configuration: configuration)
        }()
        edamamService = EdamamService(edamamSession: manager)
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

    func testGetRecipeWithValidIngradients() {
        // Given
        let ingredients = ["Apple"]
        
        let mockedData = MockedData.exampleJSON
        let mock = Mock(url: originalURL, dataType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()

        let getRecipesExpectation = self.expectation(description: "getRecipes")
        var successResult: Bool?
        var responseResult: Welcome?
        var errorResult: Error?
        
        // When
        edamamService.getRecipes(for: ingredients) { success, response in
            successResult = success
            responseResult = response
            getRecipesExpectation.fulfill()
        }
        
        wait(for: [getRecipesExpectation], timeout: 1.0)
        
        // Then
        XCTAssertTrue(successResult ?? false, "Request should be successful.")
        XCTAssertNotNil(responseResult, "Response should not be nil.")
        XCTAssertNil(errorResult, "Error should be nil.")
        
        // Clean up
        tearDown()
    }
    
//    func testGetRecipeWithEmptyIngredients() {
//        // Given
//
//        // When
//        let expectation = self.expectation(description: "getRecipes")
//        let ingredients: [String] = []
//        edamamService.getRecipes(for: ingredients){ success, response in
//            // Then
//            XCTAssertFalse(success, "La requête a réussi, mais elle devrait échouer avec des ingrédients vides.")
//            XCTAssertNil(response, "la réponse devrait être nulle avec des ingredients vides")
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 0.01)
//
//    }
    
//    func testGetRecipeWithInvalidCredentials() {
//        // Given
//
//        // When
//        let expectation = self.expectation(description: "getRecipes")
//        let invalidConfig = EndpointConfig(url: "https://api.edamam.com/api/recipes/v2?type=public&beta=false",
//                                           app_id: "",
//                                           app_key: "")
//
//        let invalidEdamamService = EdamamService(config: invalidConfig)
//
//        let ingredients = ["chicken", "rice"]
//        invalidEdamamService.getRecipe(for: ingredients){ success, response in
//            // Then
//            XCTAssertFalse(success, "La requête a réussi, mais elle devrait échouer avec des ingrédients vides.")
//            XCTAssertNil(response, "La réponse devrait être nulle avec des clés d'accès incorrectes.")
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 0.01)
//    }
}
