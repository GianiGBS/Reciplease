//
//  DetailsViewController.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 10/05/2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTtile: UILabel!
    @IBOutlet weak var ingredientsList: UILabel!
    @IBOutlet weak var favButton: UIButton!

    // MARK: - Properties
    var selectedRecipe: Recipe?
    private let coreDataManager = CoreDataManager()
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(recipe: selectedRecipe)
    }
    // MARK: - Actions
    @IBAction func favButtonTapped(_ sender: Any) {
        save(recipe: selectedRecipe)
        
    }
    @IBAction func getDirectionsTapped(_ sender: Any) {
        
    }
    
    // MARK: - Methods
    /// Update View with recipe's details
    func updateView(recipe: Recipe?) {
        guard let recipe = recipe,
              let url = recipe.url,
              let imageUrl = recipe.image,
              let title = recipe.label,
              let info = recipe.ingredientLines?.joined(separator: "\n -")
                
        else { return }
        
        recipeImage.load(url: URL(string: imageUrl)!)
        recipeTtile.text = title
        ingredientsList.text = " -" + info
        if coreDataManager.checkIfItemExist(url: url) {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    /// Checking fav button
    func checkFavButton() {
        if let recipeUrl = selectedRecipe?.url, coreDataManager.checkIfItemExist(url: recipeUrl) {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    // TODO: Verifier le separateur de la liste d'ingredient
    /// Save selected recipe in CoreData
    private func save(recipe: Recipe?) {
        if let recipeUrl = selectedRecipe?.url, let recipe = selectedRecipe {
            if coreDataManager.checkIfItemExist(url: recipeUrl) {
                coreDataManager.deleteOneRecipes(url: recipeUrl)
                favButton.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                coreDataManager.addRecipesToFav(recipe: recipe)
                favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }
}

// MARK: - Extension
/// Download image from URL
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
