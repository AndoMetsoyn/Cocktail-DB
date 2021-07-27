//
//  DrinksTableViewCell.swift
//  Cocktail-DB
//
//  Created by Ando Metsoyan on 7/26/21.
//

import UIKit
import SDWebImage

class DrinksTableViewCell: UITableViewCell {

    @IBOutlet private weak var drinkImage: UIImageView!
    @IBOutlet private weak var drinkName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setModel(_ model: CategoryDrinks) {
        if let url = URL(string: model.strDrinkThumb ?? "") {
            self.drinkImage.sd_setImage(with: url, completed: nil)
        }
        if let name = model.strDrink {
            self.drinkName.text = name
        }
    }
}
