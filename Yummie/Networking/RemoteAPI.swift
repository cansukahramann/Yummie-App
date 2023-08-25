//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

protocol RemoteAPI {
    func fetchCategories(completion: @escaping (Result<AllDishes, Error>) -> Void)
    func placeOrder(dishId: String, name: String, completion: @escaping (Result<Order, Error>) -> Void)
    func fetchCategoryDishes(categoryId: String, completion: @escaping (Result<[Dish], Error>) -> Void)
    func fetchOrders(completion: @escaping (Result<[Order], Error>) -> Void)
}
