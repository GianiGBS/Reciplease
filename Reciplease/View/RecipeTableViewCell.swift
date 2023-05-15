//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 12/05/2023.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - Navigation
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: - Methods
    func configure(background: String, title: String, subtitle: String) {
        backgroundImage.image = UIImage(named: background)
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
