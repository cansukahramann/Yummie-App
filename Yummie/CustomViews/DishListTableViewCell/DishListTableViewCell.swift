//
//  DishListTableViewCell.swift
//  Yummie
//
//  Created by Cansu Kahraman on 15.08.2023.
//

import UIKit
import Kingfisher

class DishListTableViewCell: UITableViewCell {
    
    static let identifer = String(describing: DishListTableViewCell.self)

    @IBOutlet var dishImageView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    
    func setup(dish: Dish){
        dishImageView.kf.setImage(with: dish.image?.asURL)
        titleLbl.text = dish.name
        descriptionLbl.text = dish.description
    }
    
    func setup(order:Order){
        dishImageView.kf.setImage(with: order.dish?.image?.asURL)
        titleLbl.text = order.dish?.name
        descriptionLbl.text =  order.name
    }
}
