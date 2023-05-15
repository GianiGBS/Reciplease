//
//  Recipe.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 27/04/2023.
//

import Foundation


// MARK: - Welcome
struct Welcome: Decodable {
    let from, to, count: Int?
    let links: WelcomeLinks?
    let hits: [Hit]?

    enum CodingKeys: String, CodingKey {
        case from, to, count
        case links = "_links"
        case hits
    }
}

// MARK: - Hit
struct Hit: Decodable {
    let recipe: Recipe?
    let links: HitLinks?

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
    }
}

// MARK: - HitLinks
struct HitLinks: Decodable {
    let linksSelf: Next?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - Next
struct Next: Decodable {
    let href: String?
    let title: String?
}

// MARK: - Recipe
struct Recipe: Decodable {
    let uri: String?
    let label: String?
    let image: String?
    let images: Images?
    let source: String?
    let url: String?
    let shareAs: String?
    let yield: Int?
    let dietLabels, healthLabels, cautions, ingredientLines: [String]?
    let ingredients: [Ingredient]?
    let calories, totalWeight: Double?
    let totalTime: Int?
    let cuisineType, mealType, dishType: [String]?
    let totalNutrients, totalDaily: [String: Total]?
    let digest: [Digest]?
}

// MARK: - Digest
struct Digest: Decodable {
    let label, tag: String?
    let schemaOrgTag: String?
    let total: Double?
    let hasRDI: Bool?
    let daily: Double?
    let unit: String?
    let sub: [Digest]?
}

// MARK: - Images
struct Images: Decodable {
    let thumbnail, small, regular, large: Large?

    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

// MARK: - Large
struct Large: Decodable {
    let url: String?
    let width, height: Int?
}

// MARK: - Ingredient
struct Ingredient: Decodable {
    let text: String?
    let quantity: Double?
    let measure: String?
    let food: String?
    let weight: Double?
    let foodCategory, foodID: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight, foodCategory
        case foodID = "foodId"
        case image
    }
}

// MARK: - Total
struct Total: Decodable {
    let label: String?
    let quantity: Double?
    let unit: String?
}

// MARK: - WelcomeLinks
struct WelcomeLinks: Decodable {
    let next: Next?
}
