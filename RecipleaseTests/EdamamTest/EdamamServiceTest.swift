//
//  EdamamServiceTest.swift
//  RecipleaseTests
//
//  Created by Giovanni Gabriel on 25/07/2023.
//

import XCTest
import Alamofire
@testable import Reciplease

class EdamamServiceTests: XCTestCase {

    private var edamamService: EdamamService!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

// Test lorsque la reponse est bonne
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
            XCTAssert(recipe != nil) // La reponse doit être non nulle
            XCTAssert(error == nil) // Aucune erreur ne doit survenir
        }
    }

// Test lorsque la reponse de l'API est vide
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
            XCTAssert(recipe == nil) // La reponse doit être nulle
            XCTAssert(error == nil ) // Aucune erreur ne doit survenir
        }
    }

    // Test lorsque la reponse de l'API est invalide
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
            XCTAssert(recipe == nil) // La reponse doit être nulle
            XCTAssert(error != nil ) // Une erreur doit survenir
        }
    }

    // Test lorsque l'API renvoie une erreur
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
            XCTAssert(recipe == nil) // La reponse doit être nulle en raison de l'erreur API
            XCTAssert(error != nil ) // Une erreur doit survenir
        }
    }

    // Test lorsque la liste des ingredients est vide
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
            XCTAssert(recipe == nil) // La reponse doit être nulle en raison de l'erreur API
            XCTAssert(error == nil ) // Aucund erreur ne doit survenir
        }
    }
}
