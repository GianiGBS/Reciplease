//
//  Recipes.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 16/08/2023.
//

// MARK: - Recipes
struct Recipes: Decodable {
    let from, to, count: Int?
    let hits: [Hit]?

}

// MARK: - Large
struct Large: Decodable {
    let url: String?
    let width, height: Int?
}
