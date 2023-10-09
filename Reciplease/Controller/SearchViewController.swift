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
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchForRecipeButton: UIButton!

    // MARK: - Properties
    private var isBookmarksView: Bool {
        return tabBarController?.selectedIndex == 0
    }
    private let segueIdentifier = "segueToResult"
    static var cellIndentifier = "IngredientCell"
    var ingredientSearchList: [String] = []

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        ingredientTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if let tableVC = segue.destination as? ListTableViewController {
                tableVC.ingredients = ingredientSearchList
            }
        }
    }

    // MARK: - Actions
    @IBAction func addButtonTapped() {
        guard let ingredientName = ingredientTextField.text?.trimmingCharacters(
            in: .whitespacesAndNewlines).trimmingCharacters(
                in: .punctuationCharacters), !ingredientName.isEmpty  else {
                presentAlert(title: "Entrée vide",
                             message: "Il faut entrer des ingredients.\nVeuillez réessayer.")
            return
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
//        toggleActivityIndicator(shown: true)
       ingredientForSearchShouldReturn()
    }

    // MARK: - Methods
    func ingredientForSearchShouldReturn() {
        if ingredientSearchList.isEmpty {
            presentAlert(title: "Entrée vide",
                              message: "Il faut entrer des ingredients.\nVeuillez réessayer.")
        } else {
            performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    }
    func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - UITableView - DataSource
extension SearchViewController: UITableViewDataSource {
    // MARK: Number of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // MARK: Number of Rows in Sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredientSearchList.count
    }
    // MARK: Cell for Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.cellIndentifier, for: indexPath)

        let ingredient = ingredientSearchList[indexPath.row]

        cell.textLabel?.text = ingredient.capitalized

        return cell
    }
}
// MARK: - UITableView - Delegate
extension SearchViewController: UITableViewDelegate {
    // MARK: Editing Style
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientSearchList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
