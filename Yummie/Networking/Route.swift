//
//  Route.swift
//  Yummie
//
//  Created by Cansu Kahraman on 18.08.2023.
//

import Foundation

enum Route {
    
    static let baseUrl = "https://yummie.glitch.me"
    
    case fetchAllCategories
    case placeOrder(String)
    case fetchCategoryDishes(String)
    case fetchOrders
    
    var description: String {
        switch self{
        case .fetchAllCategories:
            return "/dish-categories"
        case .placeOrder(let dishId):
            return "/orders/\(dishId)"
        case.fetchCategoryDishes(let categoryId):
            return "/dishes/\(categoryId)"
        case.fetchOrders:
            return "/orders"
        }
    }
}
 
