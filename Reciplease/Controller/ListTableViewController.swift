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
    @IBOutlet weak var containerView: UIView!

    // MARK: - Properties
    var tabBarIndex = 0
    var ingredients: [String] = []
    public var recipes: [Recipe]? = []
    private let segueIdentifier = "SeachToDetail"
    let cellIdentifier = "RecipeCell"
    private var selectedRecipe: Recipe?
    var selectedRow = 0
    private let recipeModel = EdamamManager()
    private let coreDataModel = CoreDataManager()

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
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
                detailVC.selectedRecipe = recipes?[selectedRow]
            }
        }
    }

    // MARK: - Methods
    func setupTabBar() {
        if let tabBarTag = self.tabBarController?.tabBar.selectedItem?.tag {
            self.tabBarIndex =  tabBarTag
        }
    }
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    func setUpDelegateModel() {
        recipeModel.delegate = self
    }
    func loadData() {
        if tabBarIndex == 0 { // Search
            containerView.isHidden = true
            recipeModel.fetchData(for: ingredients)
        } else if tabBarIndex == 1 { // Favoris
            toggleActivityIndicator(shown: false)
            checkFavRecipes()
        }
        tableView.reloadData()
    }
    func checkFavRecipes() {
        let fetchedRecipes = coreDataModel.fetchFavRecipes()
        if !fetchedRecipes.isEmpty {
            // Show ListTableView with fav
            containerView.isHidden = true
            recipes = fetchedRecipes
        } else {
            // Show Empty FavoriteViewController
            containerView.isHidden = false
        }
    }
    func refreshData() {
        coreDataModel.refresh()
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
        guard let recipe = recipes else {
            return 0
        }
        return recipe.count
    }
    // MARK: Cell for Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                             for: indexPath) as? RecipeTableViewCell
        else { return UITableViewCell() }

        guard let recipe = recipes?[indexPath.row],
              let imageUrl = recipe.image,
              let title = recipe.label,
              let subtitle = recipe.ingredientLines?.joined(separator: ", "),
              let yield = recipe.yield,
              let totalTime = recipe.totalTime

        else { return recipeCell }
        // Configuration of recipeCell
        recipeCell.configure(imageUrl: URL(string: imageUrl)!,
                             title: title,
                             subtitle: subtitle,
                             yield: yield,
                             totalTime: totalTime)

        return recipeCell
    }
}
// MARK: - UITableView - Delegate
extension ListTableViewController: UITableViewDelegate {
    // MARK: Did Select Row At
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.selectedRow = indexPath.row
            performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    }

// MARK: - ViewDelegate
extension ListTableViewController: ViewDelegate {

    func updateView() {
            if tabBarIndex == 0 { // Search
                containerView.isHidden = true
                recipes = recipeModel.searchRecipes
            } else if tabBarIndex == 1 { // Favoris
                toggleActivityIndicator(shown: false)
                checkFavRecipes()
            }
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
