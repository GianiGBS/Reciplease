//
//  ContainerViewController.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 30/06/2023.
//

import UIKit

class ContainerViewController: UIViewController {
    // MARK: - Properties
    private let coreDataModel = CoreDataManager()
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    private let firstVC = ListTableViewController()
    private let secondVC = FavoriteViewController()
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
//        setup()
        checkRecipes()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Methods
//    func setup() {
//        /// Add child ViewController to the container
//        addChild(firstVC)
//        addChild(secondVC)
//
//        /// Add view of  the child ViewController to the container
//        self.view.addSubview(firstVC.view)
//        self.view.addSubview(secondVC.view)
//
//        /// Pass child status to parent to show the view
//        firstVC.didMove(toParent: self)
//        secondVC.didMove(toParent: self)
//
//        /// Set the frame of each view
//        firstVC.view.frame = self.view.bounds
//        secondVC.view.frame = self.view.bounds
//
//        checkRecipes()
//    }
    
    private func checkRecipes() {
//        firstVC.view.isHidden = true
//        secondVC.view.isHidden = true
        firstVC.isCoreData = true
        
        if coreDataModel.recipeList.count > 0 {
            /// Show ListTableViewController
            firstView.isHidden = false
//            firstVC.view.isHidden = false
            firstVC.isCoreData = true
        } else {
            /// Show FavoriteViewController
//            secondVC.view.isHidden = false
            secondView.isHidden = false
            
        }
    }
}
