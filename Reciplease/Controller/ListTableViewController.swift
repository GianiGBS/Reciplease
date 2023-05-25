//
//  ListTableViewController.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 11/05/2023.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    // MARK: - Properties
    let recipeModel = RecipeManager()
    var ingredients : [String] = []
    public var recipes: [Recipe] = []
    let cellIndentifier = "RecipeCell"

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeModel.delegate = self
        recipeModel.getData(ingredientToFound: ingredients)
        tableView.rowHeight = 200
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipecell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = recipes[indexPath.row]
        
        guard let imageUrl = recipe.image,
              let title = recipe.label,
              let subtitle = recipe.ingredientLines?.joined(separator: ", ")
        else {
            return recipecell
        }
        recipecell.configure(imageUrl: URL(string: imageUrl)!, title: title, subtitle: subtitle)
        
        return recipecell
    }
}

// MARK: - Delegate Pattern
extension ListTableViewController: ViewDelegate {

    func updateView() {
        self.recipes = recipeModel.recipeList
        tableView.reloadData()
//        toggleActivityIndicator(shown: false)
    }
    
    func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    internal func toggleActivityIndicator(shown: Bool) {
//        convertButton.isUserInteractionEnabled = !shown
//        activityIndicator.isHidden = !shown
    }
    
}
