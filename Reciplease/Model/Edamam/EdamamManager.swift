//
//  EdamamManager.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 08/05/2023.
//

import Foundation

// MARK: - Change
class EdamamManager {

    // MARK: - Properties
    private (set) var recipeList: [Recipe] = []
    let recipeService = EdamamService()
    public weak var delegate: ViewDelegate?

    // MARK: - Methods
    public func fetchData(for ingredients: [String]) {

        recipeService.getRecipes(for: ingredients) { [weak self] recipes, error in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    self?.handleError(error)
                } else if let recipes = recipes {
                    self?.recipeList = (recipes.hits?.compactMap {$0.recipe})!
                    self?.delegate?.updateView()
                }
            }
        }
    }
    // MARK: - Private Methods
        private func handleError(_ error: Error) {
            // Handle the error appropriately, e.g., show an alert or log it.
            delegate?.presentAlert(title: "Erreur de chargement",
                                   message: "Une erreur lors du chargement des données. Veuillez réessayer plus tard.")
        }
}
