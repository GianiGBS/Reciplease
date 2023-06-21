//
//  FavoriteViewController.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 11/04/2023.
//

import UIKit

class FavoriteViewController: UIViewController {
    // MARK: - Properties
    private let segueIdentifier = ""
    private let coreDataManager = CoreDataManager()
    private let recipeTableVC = ListTableViewController(isCoreData: true)
    
    private var favRecipes: [Recipe] = []
    
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipes()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableVC = segue.destination as? ListTableViewController {
            tableVC.recipes = self.favRecipes
        }
    }
    // MARK: - Methods
    private func getRecipes() {
        self.favRecipes = coreDataManager.getRecipes()
    }
    private func deleteRecipes(){
        
    }

}
