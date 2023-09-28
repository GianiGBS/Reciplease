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
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!

    // MARK: - Properties
    var selectedRecipe: Recipe?
    private let coreDataModel = CoreDataManager()

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView(recipe: selectedRecipe)
    }
    // MARK: - Actions
    @IBAction func favButtonTapped(_ sender: UIBarButtonItem) {
        save(recipe: selectedRecipe)

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
              let score = recipe.yield,
              let time = recipe.totalTime,
              let info = recipe.ingredientLines?.joined(separator: "\n -")

        else { return }

        recipeImage.download(url: URL(string: imageUrl)!)
        recipeTtile.text = title
        yieldLabel.text = "\(String(score))"
        totalTimeLabel.text = formatTime(time)
        ingredientsList.text = " -" + info
        if coreDataModel.checkIfItemExist(url: url) {
            favButton.image = UIImage(systemName: "heart.fill")
        } else {
            favButton.image = UIImage(systemName: "heart")
        }
    }
    /// Checking fav button
    func checkFavButton() {
        if let recipeUrl = selectedRecipe?.url, coreDataModel.checkIfItemExist(url: recipeUrl) {
            favButton.image = UIImage(systemName: "heart.fill")
        } else {
            favButton.image = UIImage(systemName: "heart")
        }
    }
    /// Save selected recipe in CoreData
    private func save(recipe: Recipe?) {
        if let recipeUrl = selectedRecipe?.url, let recipe = selectedRecipe {
            if coreDataModel.checkIfItemExist(url: recipeUrl) {
                do {
                    try coreDataModel.deleteOneRecipeFromFav(url: recipeUrl)
                    favButton.image = UIImage(systemName: "heart")
                } catch {
                    print(error)
                }
                print("Recipe Delete")
            } else {
                do {
                    try coreDataModel.addRecipeToFav(recipe: recipe)
                    favButton.image = UIImage(systemName: "heart.fill")
                } catch {
                    print(error.localizedDescription)
                }
                print("Recipe Save")
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
    func download(url: URL) {
        // download in async way with URLSession
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  // check MIMI response
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  // check data
                let data = data, error == nil,
                  // convert data to UIImage
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}
