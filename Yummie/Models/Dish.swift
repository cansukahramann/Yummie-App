//
//  Dish.swift
//  Yummie
//
//  Created by Cansu Kahraman on 14.08.2023.
//

import Foundation

struct Dish: Decodable{
    let id, name, description, image: String?
    let calories: Int?
    
    var formattedCalories: String{
        return String(format: "\(calories!) calories", calories ?? 0)
    }
}
