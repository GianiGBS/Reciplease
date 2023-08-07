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
    private let coreDataModel = CoreDataManager()
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(recipe: selectedRecipe)
    }
    // MARK: - Actions
    @IBAction func favButtonTapped(_ sender: Any) {
        save(recipe: selectedRecipe)
//    TODO: Reload TableView
        
    }
    @IBAction func getDirectionsTapped(_ sender: Any) {
        guard let recipe = selectedRecipe,
              let directionUrl = recipe.url,
              let url = URL(string: directionUrl)
        else {
            presentAlert(title: "Error", message: "Invalide recipe URL.")
            return
        }
        UIApplication.shared.open(url)
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
        if coreDataModel.checkIfItemExist(url: url) {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    /// Checking fav button
    func checkFavButton() {
        if let recipeUrl = selectedRecipe?.url, coreDataModel.checkIfItemExist(url: recipeUrl) {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    // TODO: Verifier le separateur de la liste d'ingredient
    /// Save selected recipe in CoreData
    private func save(recipe: Recipe?) {
        if let recipeUrl = selectedRecipe?.url, let recipe = selectedRecipe {
            if coreDataModel.checkIfItemExist(url: recipeUrl) {
                do {
                    try coreDataModel.deleteOneRecipes(url: recipeUrl)
                    
                } catch {
                    print(error)
                }
                favButton.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                do {
                    try coreDataModel.addRecipesToFav(recipe: recipe)
                    favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
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
