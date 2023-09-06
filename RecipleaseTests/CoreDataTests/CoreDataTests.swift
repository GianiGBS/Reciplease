//
//  CoreDataTests.swift
//  RecipleaseTests
//
//  Created by Giovanni Gabriel on 25/07/2023.
//

import XCTest
import CoreData
@testable import Reciplease

class CoreDataManagerTests: XCTestCase {
    // MARK: - Properties
    var coreDataStack: CoreDataStackTest!
    var coreDataManager: CoreDataManager!

    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataStack = CoreDataStackTest.sharedTinstance
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }

    override func tearDownWithError() throws {
        coreDataStack = nil
        coreDataManager = nil
        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testAddRecipeToFavorites() {
        // Given
        let recipe = Recipe(uri: "recipe1", label: "Recipe 1",
                            image: "image1", source: "Source 1",
                            url: "url1", yield: 0,
                            ingredientLines: ["ingredient1", "ingredient2"], totalTime: 0)
        // When
        do {
            try coreDataManager.addRecipesToFav(recipe: recipe)
            let recipes = coreDataManager.getAllFavRecipes()
            // Then
            XCTAssertTrue(recipes.contains { $0.uri == "recipe1" })
        } catch {
            XCTFail("Adding recipe to favorites failed with error: \(error.localizedDescription)")
        }
    }

    func testDeleteRecipeFromfavorites() {
        //  Given
        let recipe = Recipe(uri: "recipe1", label: "Recipe 1",
                            image: "image1", source: "Source 1",
                            url: "url1", yield: 0,
                            ingredientLines: ["ingredient1", "ingredient2"], totalTime: 0)
        //  When
        do {
            try coreDataManager.addRecipesToFav(recipe: recipe)
            try coreDataManager.deleteOneRecipes(url: "url1")
            let recipes = coreDataManager.getAllFavRecipes()
            //  Then
            XCTAssertFalse(recipes.contains {$0.uri == "recipe1"})
        } catch {
            XCTFail("Deleting recipe from favorites failed with error: \(error.localizedDescription)")
        }
    }

    func testCheckIfItemExist() {
        //  Given
        let recipe = Recipe(uri: "recipe1", label: "Recipe 1",
                            image: "image1", source: "Source 1",
                            url: "url1", yield: 0,
                            ingredientLines: ["ingredient1", "ingredient2"], totalTime: 0)
        //   When
        do {
            try coreDataManager.addRecipesToFav(recipe: recipe)
            //  Then
            XCTAssertTrue(coreDataManager.checkIfItemExist(url: "url1"))
            XCTAssertFalse(coreDataManager.checkIfItemExist(url: "url2"))
        } catch {
            XCTFail("Error while testing checkIfItemExist: \(error.localizedDescription)")
        }
    }
}
