//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 11/04/2023.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var searchBarView: UISearchBar!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    static var cellIndentifier = "IngredientCell"
    var ingredientSearchList : [String] = []
    let recipeManager = RecipeManager()

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeManager.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Actions
    @IBAction func addButtonTapped() {
        guard let ingredientName = ingredientTextField.text, !ingredientName.isEmpty  else {
                return
        }
        ingredientSearchList.append(ingredientName)
        tableView.reloadData()
    }
    @IBAction func clear() {
        ingredientSearchList.removeAll()
        tableView.reloadData()
    }
    @IBAction func searchForRecipeTapped() {
        recipeManager.getData(ingredientToFound: ingredientSearchList)
        
    }
    // MARK: - Methods
    func ingredientForSearchShouldReturn(ingredients: [String]?) {
        guard let listOfIngredients = ingredients, !listOfIngredients.isEmpty else {
        return self.presentAlert(title: "Entrée vide",
                          message: "Il faut entrer le texte.\nVeuillez réessayer.")
    }
        recipeManager.getData(ingredientToFound: ingredients!)
    return
    }
}
// MARK: - Delegate Pattern
extension SearchViewController: ViewDelegate {
    func updateView() {
        guard let data = recipeManager.data, !data.label.isEmpty else {
            return self.presentAlert(title: "Erreur", message: "Aucune données.")
    }
        //textViewTo.text = "\(data.data.translations[0].translatedText)"

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
// MARK: - UITableView - Delegate
extension SearchViewController: UITableViewDelegate {
    
}
// MARK: - UITableView - DataSource
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        IngredientService.shared.ingredientSearchList.count
        ingredientSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.cellIndentifier, for: indexPath)
//        let ingredient = IngredientService.shared.ingredientSearchList[indexPath.row]
        let ingredient = ingredientSearchList[indexPath.row]
//        UIListContentConfiguration
        cell.textLabel?.text = ingredient
        
        return cell
    }
    
    
}
