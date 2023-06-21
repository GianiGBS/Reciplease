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
        
        // Do any additional setup after loading the view.
    }
    // MARK: - Actions
    @IBAction func favButtonTapped(_ sender: Any) {
//        TODO: Save CoreData et Desing fill
        save(recipe: selectedRecipe)
        self.favButton.isSelected = true
        
    }
    @IBAction func getDirectionsTapped(_ sender: Any) {
        
    }
    // MARK: - Methods
    
    func updateView(recipe: Recipe?) {
        guard let recipe = recipe,
              let imageUrl = recipe.image,
              let title = recipe.label,
              let info = recipe.ingredientLines?.joined(separator: "\n -")
        else { return }
        
        recipeImage.load(url: URL(string: imageUrl)!)
        recipeTtile.text = title
        ingredientsList.text = " -" + info
    }
    private func save(recipe: Recipe?) {
        guard let uri = recipe?.uri,
              let label = recipe?.label,
              let image = recipe?.image,
              let source = recipe?.source,
              let url = recipe?.url,
              let ingredientLines = recipe?.ingredientLines?.joined(separator: "\n -")
        else { return }
        coreDataManager.addRecipes(uri: uri,
                                   label: label,
                                   image: image,
                                   source: source,
                                   url: url,
                                   ingredientLines: ingredientLines) { 
        }
    }
}

// MARK: - Download image from URL
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
