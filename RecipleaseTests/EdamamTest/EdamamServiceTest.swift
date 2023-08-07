//
//  EdamamServiceTest.swift
//  RecipleaseTests
//
//  Created by Giovanni Gabriel on 25/07/2023.
//

import XCTest
@testable import Reciplease
@testable import Alamofire

class EdamamServiceTests: XCTestCase {
    
    var edamamService: EdamamService!
    
    override func setUp() {
        super.setUp()
        let config = EdamamConfig()
        let session = URLSessionConfiguration.default
        session.protocolClasses = [MockURLProtocol.self]
        
        
        edamamService = EdamamService(config: config, session: session)
        
    }
    
    func testGetRecipeWithValidIngradients() {
        // Given
        
        // When
        let expectation = self.expectation(description: "getRecipes")
        let ingredients = ["chicken", "rice"]
        edamamService.getRecipes(for: ingredients) { success, response in
            // Then
            XCTAssertTrue(success, "La requête a échoué.")
            XCTAssertNotNil(response, "La reponse est nulle.")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeWithEmptyIngredients() {
        // Given
        
        // When
        let expectation = self.expectation(description: "getRecipes")
        let ingredients: [String] = []
        edamamService.getRecipes(for: ingredients){ success, response in
            // Then
            XCTAssertFalse(success, "La requête a réussi, mais elle devrait échouer avec des ingrédients vides.")
            XCTAssertNil(response, "la réponse devrait être nulle avec des ingredients vides")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
            
    }
    
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
