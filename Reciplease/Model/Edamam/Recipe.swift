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
//    let images: Images?
    let source: String?
    let url: String?
//    let yield: Int?
    let ingredientLines: [String]?
//    let calories: Double?
//    let totalTime: Int?
}

// MARK: - Large
struct Large: Decodable {
    let url: String?
    let width, height: Int?
}

// MARK: - WelcomeLinks
struct WelcomeLinks: Decodable {
    let next: Next?
}
