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
    func configure(imageUrl: URL, title: String, subtitle: String) {
        backgroundImage.load(url: imageUrl)
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
