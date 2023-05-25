//
//  DetailsViewController.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 10/05/2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTtile: UILabel!
    @IBOutlet weak var ingredientsList: UILabel!
    @IBOutlet weak var favButton: UIButton!

    // MARK: - Properties

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // MARK: - Actions
    @IBAction func favButtonTapped(_ sender: Any) {
        
    }
    @IBAction func getDirectionsTapped(_ sender: Any) {
        
    }
    // MARK: - Methods
    
}

// MARK: - Download image from URL
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
