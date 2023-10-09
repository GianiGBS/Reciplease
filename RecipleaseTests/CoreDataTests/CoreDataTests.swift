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
        let recipe = Recipe(uri: "recipe1",
                            label: "Recipe 1",
                            image: "image1",
                            source: "Source 1",
                            url: "url1", yield: 0,
                            ingredientLines: ["ingredient1", "ingredient2"],
                            totalTime: 0)
        // When
        do {
            try coreDataManager.addRecipeToFav(recipe: recipe)
            let recipes = coreDataManager.fetchFavRecipes()
            // Then
            XCTAssertTrue(recipes.contains { $0.uri == "recipe1" })
        } catch {
            XCTFail("Adding recipe to favorites failed with error: \(error.localizedDescription)")
        }
    }

    func testDeleteRecipeFromfavorites() {
        //  Given
        let recipe = Recipe(uri: "recipe1",
                            label: "Recipe 1",
                            image: "image1",
                            source: "Source 1",
                            url: "url1",
                            yield: 0,
                            ingredientLines: ["ingredient1", "ingredient2"],
                            totalTime: 0)
        //  When
        do {
            try coreDataManager.addRecipeToFav(recipe: recipe)
            try coreDataManager.deleteOneRecipeFromFav(url: "url1")
            let recipes = coreDataManager.fetchFavRecipes()
            //  Then
            XCTAssertFalse(recipes.contains {$0.uri == "recipe1"})
        } catch {
            XCTFail("Deleting recipe from favorites failed with error: \(error.localizedDescription)")
        }
    }

    func testCheckIfItemExist() {
        //  Given
        let recipe = Recipe(uri: "recipe1",
                            label: "Recipe 1",
                            image: "image1",
                            source: "Source 1",
                            url: "url1",
                            yield: 0,
                            ingredientLines: ["ingredient1", "ingredient2"],
                            totalTime: 0)
        //   When
        do {
            try coreDataManager.addRecipeToFav(recipe: recipe)
            //  Then
            XCTAssertTrue(coreDataManager.checkIfItemExist(url: "url1"))
            XCTAssertFalse(coreDataManager.checkIfItemExist(url: "url2"))
        } catch {
            XCTFail("Error while testing checkIfItemExist: \(error.localizedDescription)")
        }
    }
// Cas Limite
    func testAddRecipeTwiceToFavorites() {
        // Given
        let recipe = Recipe(uri: "recipe1",
                            label: "Recipe 1",
                            image: "image1",
                            source: "Source 1",
                            url: "url1",
                            yield: 0,
                            ingredientLines: ["ingredient1", "ingredient2"],
                            totalTime: 0)

        // When
        do {
            try coreDataManager.addRecipeToFav(recipe: recipe)
            try coreDataManager.addRecipeToFav(recipe: recipe)

            let recipes = coreDataManager.fetchFavRecipes()

            // Then
            XCTAssertEqual(recipes.filter { $0.uri == "recipe1" }.count, 1)
        } catch {
            XCTFail("Adding the same recipe twice to favorites failed with error: \(error.localizedDescription)")
        }
    }

    func testDeleteNonExistingRecipeFromFavorites() {
        // When
        do {
            try coreDataManager.deleteOneRecipeFromFav(url: "nonexistentUrl")
            let recipes = coreDataManager.fetchFavRecipes()

            // Then
            // Ensure that deleting a non-existing recipe does not change the favorites
            XCTAssertEqual(recipes.count, 0)
        } catch {
            XCTFail("Deleting a non-existing recipe from favorites should not fail: \(error.localizedDescription)")
        }
    }

    func testDeleteAllRecipesFromFavorites() {
        // Given
        let recipe1 = Recipe(uri: "recipe1",
                             label: "Recipe 1",
                             image: "image1",
                             source: "Source 1",
                             url: "url1",
                             yield: 0,
                             ingredientLines: ["ingredient1", "ingredient2"],
                             totalTime: 0)
        let recipe2 = Recipe(uri: "recipe2",
                             label: "Recipe 2",
                             image: "image2",
                             source: "Source 2",
                             url: "url2",
                             yield: 0,
                             ingredientLines: ["ingredient3", "ingredient4"],
                             totalTime: 0)

        // When
        do {
            try coreDataManager.addRecipeToFav(recipe: recipe1)
            try coreDataManager.addRecipeToFav(recipe: recipe2)
            try coreDataManager.deleteAllRecipesFromFav()
            let recipes = coreDataManager.fetchFavRecipes()

            // Then
            XCTAssertEqual(recipes.count, 0)
        } catch {
            XCTFail("Deleting all recipes from favorites failed with error: \(error.localizedDescription)")
        }
    }

    func testFetchFavRecipesWithEmptyFavorites() {
        // When
        let recipes = coreDataManager.fetchFavRecipes()

        // Then
        XCTAssertEqual(recipes.count, 0)
    }
}
