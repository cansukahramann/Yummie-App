//
//  DishPortraitCollectionViewCell.swift
//  Yummie
//
//  Created by Cansu Kahraman on 14.08.2023.
//

import UIKit
import Kingfisher

class DishPortraitCollectionViewCell: UICollectionViewCell {
    
    static let identifer = String(describing: DishPortraitCollectionViewCell.self)

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var dishImageView: UIImageView!
    @IBOutlet var caloriesLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    
    
    func setup(dish: Dish){
        titleLbl.text = dish.name
        dishImageView.kf.setImage(with: dish.image?.asURL)
        caloriesLbl.text = dish.formattedCalories
        descriptionLbl.text = dish.description
    }
    
}
