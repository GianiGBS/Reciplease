//
//  RecipeURL.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 03/05/2023.
//

import Foundation

// MARK: - Recipe API

class RecipeAPI {
    
    // MARK: - Properties
    
    private static let endpoint = "https://api.edamam.com/api/recipes/v2"
    private static var parameter: String {
        return "?type=public&beta=false"
    }
    private static let accessKey = "&app_id=\(verifiedKey(accesKey: "API_RECIPE_ID"))&app_key=\(verifiedKey(accesKey: "API_RECIPE_KEY"))&q="
    static var url: String {
        return RecipeAPI.endpoint + RecipeAPI.parameter + RecipeAPI.accessKey
    }
}
