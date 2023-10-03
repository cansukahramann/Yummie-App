//
//  CategoryCollectionViewCell.swift
//  Yummie
//
//  Created by Cansu Kahraman on 10.08.2023.
//

import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell {

    static let identifer = String(describing: CategoryCollectionViewCell.self)
    
    @IBOutlet var CateogryImageView: UIImageView!
    @IBOutlet var CategoryTitleLbl: UILabel!

    func setup(category: DishCategory){
        CategoryTitleLbl.text = category.title
        CateogryImageView.kf.setImage(with: category.image?.asURL)
    }
    
}
