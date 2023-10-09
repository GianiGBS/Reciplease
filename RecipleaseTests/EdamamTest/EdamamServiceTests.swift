//
//  EdamamServiceTests.swift
//  RecipleaseTests
//
//  Created by Giovanni Gabriel on 25/07/2023.
//

import XCTest
import Alamofire
@testable import Reciplease

class EdamamServiceTests: XCTestCase {

    private var edamamService: EdamamService!

    func testGetRecipeWithValidIngradients() {
        // Given
        let mockedResult = MockedResult(response: MockedData.responseOK,
                                        data: MockedData.recipesCorrectData,
                                        error: nil)
        // When
        let mockedSession = MockEdamamSession(mockedResult: mockedResult)

        // Then
        edamamService = EdamamService(session: mockedSession)

        edamamService.getRecipes(for: ["Apple"]) { recipe, error in
            XCTAssert(recipe != nil) // Reponse should be nil
            XCTAssert(error == nil) // No error should occur
        }
    }

    func testGetRecipeWithEmptyReponse() {
        // Given
        let mockedResult = MockedResult(response: MockedData.responseOK,
                                        data: nil,
                                        error: nil)

        // When
        let mockedSession = MockEdamamSession(mockedResult: mockedResult)

        // Then
        edamamService = EdamamService(session: mockedSession)

        edamamService.getRecipes(for: ["Apple"]) { recipe, error in
            XCTAssert(recipe == nil) // Reponse should be nil
            XCTAssert(error == nil ) // No error should occur
        }
    }

    func testGetRecipeWithInvalidResponse() {
        // Given
        let mockedResult = MockedResult(response: MockedData.responseOK,
                                        data: MockedData.recipeIncorrectData,
                                        error: nil)

        // When
        let mockedSession = MockEdamamSession(mockedResult: mockedResult)

        // Then
        edamamService = EdamamService(session: mockedSession)

        edamamService.getRecipes(for: ["Apple"]) { recipe, error in
            XCTAssert(recipe == nil) // Reponse should be nil
            XCTAssert(error != nil ) // Error should occur
        }
    }

    func testGetRecipeWithAPIError() {
        // Given
        let apiError = NSError(domain: "com.edamam.api", code: 500, userInfo: nil)
        let mockedResult = MockedResult(response: nil,
                                        data: nil,
                                        error: apiError)

        // When
        let mockedSession = MockEdamamSession(mockedResult: mockedResult)

        // Then
        edamamService = EdamamService(session: mockedSession)

        edamamService.getRecipes(for: ["Apple"]) { recipe, error in
            XCTAssert(recipe == nil) // Reponse should be nil du to API's error
            XCTAssert(error != nil ) // Error should occur
        }
    }

    func testGetRecipeWithEmptyIngredients() {
        // Given
        let mockedResult = MockedResult(response: MockedData.responseOK,
                                        data: MockedData.recipesCorrectData,
                                        error: nil)

        // When
        let mockedSession = MockEdamamSession(mockedResult: mockedResult)

        // Then
        edamamService = EdamamService(session: mockedSession)

        edamamService.getRecipes(for: []) { recipe, error in
            XCTAssert(recipe == nil) // Reponse should be nil du to error
            XCTAssert(error == nil ) // No error should occur
        }
    }
}
