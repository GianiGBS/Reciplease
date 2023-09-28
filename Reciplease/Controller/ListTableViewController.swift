//
//  ListTableViewController.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 11/05/2023.
//

import UIKit

class ListTableViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties
    var ingredients: [String] = []
    public var recipes: [Recipe] = []
    private let segueIdentifier = "SeachToDetail"
    let cellIdentifier = "RecipeCell"
    private var selectedRecipe: Recipe?
    var selectedRow = 0
    let recipeModel = EdamamManager()

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpDelegateModel()
        loadData()
        tableView.rowHeight = 200
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if let detailVC = segue.destination as? DetailsViewController {
                detailVC.selectedRecipe = recipes[selectedRow]
            }
        }
    }

    // MARK: - Methods
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    func setUpDelegateModel() {
        recipeModel.delegate = self
    }
    /// Loading Data
    func loadData() {
        recipeModel.fetchData(for: ingredients)
        tableView.reloadData()
    }
}

// MARK: - UITableView - DataSource
extension ListTableViewController: UITableViewDataSource {
    // MARK: Number of Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // MARK: Number of Rows in Sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    // MARK: Cell for Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                             for: indexPath) as? RecipeTableViewCell
        else { return UITableViewCell() }

        let recipe = recipes[indexPath.row]

        guard let imageUrl = recipe.image,
              let title = recipe.label,
              let subtitle = recipe.ingredientLines?.joined(separator: ", "),
              let yield = recipe.yield,
              let totalTime = recipe.totalTime

        else { return recipeCell }

        /// Configuration of recipeCell
        recipeCell.configure(imageUrl: URL(string: imageUrl)!,
                             title: title,
                             subtitle: subtitle,
                             yield: yield,
                             totalTime: totalTime)

        return recipeCell
    }
}

// MARK: Did Select Row At
extension ListTableViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.selectedRow = indexPath.row
            performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    }

// MARK: - ViewDelegate
extension ListTableViewController: ViewDelegate {

    func updateView() {
        self.recipes = recipeModel.recipeList
        tableView.reloadData()
    }

    func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    internal func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
}
