//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 11/04/2023.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchForRecipeButton: UIButton!

    // MARK: - Properties
    static var cellIndentifier = "IngredientCell"
    var ingredientSearchList : [String] = []
    let recipeManager = RecipeManager()
    let tableViewC = ListTableViewController()

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeManager.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Actions
    @IBAction func addButtonTapped() {
        guard let ingredientName = ingredientTextField.text, !ingredientName.isEmpty  else {
                return self.presentAlert(title: "Entrée vide",
                                         message: "Il faut entrer des ingredients.\nVeuillez réessayer.")
        }
        ingredientSearchList.append(ingredientName)
        tableView.reloadData()
        ingredientTextField.text = ""
    }
    @IBAction func clearButtonTapped() {
        ingredientSearchList.removeAll()
        tableView.reloadData()
    }
    @IBAction func searchForRecipeButtonTapped() {
        ingredientForSearchShouldReturn()
        
    }
    // MARK: - Methods
    func ingredientForSearchShouldReturn() {
        if !ingredientSearchList.isEmpty {
            recipeManager.getData(ingredientToFound: ingredientSearchList)
        } else {
        self.presentAlert(title: "Entrée vide",
                          message: "Il faut entrer des ingredients.\nVeuillez réessayer.")
            
        }
    }
}
// MARK: - Delegate Pattern
extension SearchViewController: ViewDelegate {
    func updateView() {
        guard let data = recipeManager.data?.hits, !data.isEmpty else {
            return self.presentAlert(title: "Erreur", message: "Aucune données.")
    }
        print(data)
        // Afficher la tableview de recette
    }
    
    func toggleActivityIndicator(shown: Bool) {
    }
    
    func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
}
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - UISearchBar - Delegate
extension SearchViewController: UISearchBarDelegate {
    
}
// MARK: - UITableView - DataSource
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        ingredientSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.cellIndentifier, for: indexPath)

        let ingredient = ingredientSearchList[indexPath.row]

        cell.textLabel?.text = ingredient
        
        return cell
    }
    
    
}
// MARK: - UITableView - Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientSearchList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
