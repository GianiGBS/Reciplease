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
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

    func testGetRecipeWithEmptyIngredients() {
        // Given
        let ingredients: [String] = []
        
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
        XCTAssertFalse(successResult ?? true, "Request should fail with empty ingredients.")
        XCTAssertNil(responseResult, "Response should be nil.")
        XCTAssertNil(errorResult, "Error should be nil.")
        
        // Clean up (if applicable)
    }

}
