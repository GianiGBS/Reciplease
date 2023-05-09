//
//  RecipeManager.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 08/05/2023.
//

import Foundation

// MARK: - Change
class RecipeManager {

    // MARK: - Properties
    var data: Recipe?
    let recipeService = RecipeService.shared
    public weak var delegate: ViewDelegate?

    // MARK: - Methods
    public func getData(ingredientToFound: [String]) {
        self.delegate?.toggleActivityIndicator(shown: true)
        recipeService.getRecipe(for: ingredientToFound ) { success, recipe in
            self.delegate?.toggleActivityIndicator(shown: false)
            guard let recipe = recipe, success == true else {
                self.delegate?.presentAlert(title: "Echec de l'appel",
                                            message: "Fixer.API n'a pas répondu.\nVeuillez réessayer.")
                return
            }
            self.data = recipe
            self.delegate?.updateView()
        }
    }
}
