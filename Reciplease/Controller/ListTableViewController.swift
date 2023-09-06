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
    @IBOutlet weak var containerView: UIView!

    // MARK: - Properties
    var ingredients: [String] = []
    public var recipes: [Recipe] = []
    private let segueIdentifier = "segueToDetail"
    let cellIdentifier = "RecipeCell"
    private var selectedRecipe: Recipe?
    var hits: [Hit]?
    var selectedRow = 0
    let recipeModel = EdamamManager()
    let coreDataModel = CoreDataManager()

    private var isBookmarksView: Bool {
        return tabBarController?.selectedIndex == 1
    }

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRecipeModel()
        start()
        tableView.rowHeight = 200
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if let detailVC = segue.destination as? DetailsViewController {
                detailVC.selectedRecipe = recipes[selectedRow]
            }
        }
    }

    // MARK: - Init

    // MARK: - Methods
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    func setupRecipeModel() {
        recipeModel.delegate = self
    }
    /// Loading Data
    func start() {
        if isBookmarksView {
            print("Is Bookmark")
            checkRecipes()
        } else {
            print("Not Bookmark")
            containerView.isHidden = true
            recipeModel.getData(ingredientToFound: ingredients)
            tableView.reloadData()
        }
    }
    func checkRecipes() {
        if coreDataModel.getAllFavRecipes().count > 0 {
            /// Show ListTableViewController
            recipes = coreDataModel.allRecipes
            tableView.reloadData()
            containerView.isHidden = true
        } else {
            /// Show Empty FavoriteViewController
            containerView.isHidden = false
        }
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
        return recipes.count // hits?.count ?? 0
    }
    // MARK: Cell for Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                             for: indexPath) as? RecipeTableViewCell
        else { return UITableViewCell() }

//        guard let hits = hits else {
//            return UITableViewCell()
//        }

        let recipe = recipes[indexPath.row]

        guard let imageUrl = recipe.image,
              let title = recipe.label,
              let subtitle = recipe.ingredientLines?.joined(separator: ", "),
              let yield = recipe.yield,
              let totalTime = recipe.totalTime

        else { return recipeCell }

//        recipeCell.configure()
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
