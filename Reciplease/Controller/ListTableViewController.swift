//
//  ListTableViewController.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 11/05/2023.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    // MARK: - Properties
    var ingredients : [String] = []
    public var recipes: [Recipe] = []
    private let segueIdentifier = "segueToDetail"
    let cellIndentifier = "RecipeCell"
    var selectedRow = 0
    let recipeModel = RecipeManager()
    private let recipeDetailVC = DetailsViewController()

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailsViewController {
            detailVC.selectedRecipe = recipes[self.selectedRow]
        }
    }

    // MARK: - Table view data source

    // MARK: Number of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    // MARK: Number of Rows in Sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    // MARK: Cell for Row At
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipecell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? RecipeTableViewCell
        else { return UITableViewCell() }
        
        let recipe = recipes[indexPath.row]
        
        guard let imageUrl = recipe.image,
              let title = recipe.label,
              let subtitle = recipe.ingredientLines?.joined(separator: ", ")
        else { return recipecell }
        
        recipecell.configure(imageUrl: URL(string: imageUrl)!, title: title, subtitle: subtitle)
        
        return recipecell
    }
    // MARK: Did Select Row At
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        performSegue(withIdentifier: segueIdentifier, sender: self)
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
