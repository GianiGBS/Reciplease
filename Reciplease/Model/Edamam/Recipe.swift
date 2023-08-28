//
//  Recipe.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 27/04/2023.
//

//import Foundation


// MARK: - Recipe
struct Recipe: Decodable {
    let uri: String?
    let label: String?
    let image: String?
//    let images: Images?
    let source: String?
    let url: String?
//    let yield: Int?
    let ingredientLines: [String]?
//    let calories: Double?
//    let totalTime: Int?
}
