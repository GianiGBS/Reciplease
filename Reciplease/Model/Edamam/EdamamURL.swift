//
//  EdamamURL.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 03/05/2023.
//

import Foundation

// MARK: - Recipe API URL
class EdamamURL {
    static func endpoint(foodsParameter: [String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "/api/recipes/v2"
        components.queryItems = [
            URLQueryItem(name: "type", value: "public"),
            URLQueryItem(name: "app_id", value: verifiedKey(accesKey: "API_RECIPE_ID")),
            URLQueryItem(name: "app_key", value: verifiedKey(accesKey: "API_RECIPE_KEY")),
            URLQueryItem(name: "q", value: foodsParameter.joined(separator: ","))]
        return components.url
    }
}
