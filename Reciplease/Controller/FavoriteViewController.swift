//
//  FavoriteViewController.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 11/04/2023.
//

import UIKit

class FavoriteViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!

    // MARK: - Properties
    public var recipes: [Recipe] = []
    private let segueIdentifier = "FavToDetail"
    let cellIdentifier = "RecipeCell"
    private var selectedRecipe: Recipe?
    var selectedRow = 0
    private let coreDataModel = CoreDataManager()

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpCoreDataDelegateModel()
        loadData()
        tableView.rowHeight = 200
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
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
    func setUpCoreDataDelegateModel() {
        coreDataModel.delegate = self
    }
    /// Loading Data
    func loadData() {
        checkRecipes()
    }
    func checkRecipes() {
        let fetchedRecipes = coreDataModel.fetchFavRecipes()
        if !fetchedRecipes.isEmpty {
                    recipes = fetchedRecipes
                    tableView.reloadData()
                    /// Show ListTableView with fav
                    containerView.isHidden = true
                } else {
                    /// Show Empty FavoriteViewController
                    containerView.isHidden = false
                }
    }
    func refreshData() {
        coreDataModel.refresh()
        tableView.reloadData()
    }
}

// MARK: - UITableView - DataSource
extension FavoriteViewController: UITableViewDataSource {
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
// MARK: - UITableView - Delegate
extension FavoriteViewController: UITableViewDelegate {
    // MARK: Did Select Row At
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.selectedRow = indexPath.row
            performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    // MARK: Editing Style
    func tableview(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            if let recipeUrl = recipes[indexPath.row].url {
                do { try coreDataModel.deleteOneRecipeFromFav(url: recipeUrl) } catch { print(error) }
                print("Recipe Delete")
            }
        }
    }
    }

// MARK: - ViewDelegate
extension FavoriteViewController: ViewDelegate {

    func updateView() {
            self.recipes = coreDataModel.allRecipes
                tableView.reloadData()
    }

    func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    internal func toggleActivityIndicator(shown: Bool) {
    }
}
