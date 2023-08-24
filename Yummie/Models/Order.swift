//
//  Orders.swift
//  Yummie
//
//  Created by Cansu Kahraman on 16.08.2023.
//

import Foundation


struct Order: Decodable{
    let id: String?
    let name:String?
    let dish: Dish?
}
