//
//  MockedData.swift
//  RecipleaseTests
//
//  Created by Giovanni Gabriel on 11/08/2023.
//

import Foundation
public final class MockedData {
    public static let exampleJSON: Data = try! Data(contentsOf: Bundle(for: MockedData.self).url(forResource: "Recipes", withExtension: "json")!)
}

//    func test() {
//            let fakeResponse = FakeResponse(response: nil, data: nil, error: FakeResponseData.networkError)
//            let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
//            let recipeService = RecipeService(recipeSession: recipeSessionFake)
//
//            recipeService.getRecipes(ingredientsList: ingredientsList) { (success, recipesSearch) in
//
//            }
//
//        }
// 
