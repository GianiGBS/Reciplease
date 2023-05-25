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
//    var data: Welcome?
    public private (set) var recipeList: [Recipe] = []
    let recipeService = RecipeService.shared
    public weak var delegate: ViewDelegate?

    // MARK: - Methods
    public func getData(ingredientToFound: [String]) {
        // self.delegate?.toggleActivityIndicator(shown: true)
        recipeService.getRecipe(for: ingredientToFound ) { success, data in
            // self.delegate?.toggleActivityIndicator(shown: false)
            guard let data = data, success == true, let hits = data.hits else {
                self.delegate?.presentAlert(title: "Echec de l'appel",
                                            message: "EDAMAM.API n'a pas répondu.\nVeuillez réessayer.")
                return
            }
            self.recipeList = hits.compactMap {$0.recipe}
            print(self.recipeList)
            
            self.delegate?.updateView()
        }
    }
}
