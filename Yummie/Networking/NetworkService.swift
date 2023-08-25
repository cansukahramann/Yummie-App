//
//  NetworkingService.swift
//  Yummie
//
//  Created by Cansu Kahraman on 18.08.2023.
//

import Foundation

class NetworkService {
    
    #warning("remove shared instance (Singleton pattern)")
    static let shared = NetworkService()
    
    private init() {}
    
    private var currentTask: URLSessionDataTask?
    
    private func performHTTPRequest<T: Decodable>(route: Route, method: Method, parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = makeHTTPRequest(route: route, method: method, parameters: parameters) else {
            return completion(.failure(AppError.unknownError))
        }
        
        self.currentTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                JSONMapper.map(data: data, completion: completion)
            } else if let error = error {
                completion(.failure(error))
            }
        }
        currentTask?.resume()
    }
    
    private func makeHTTPRequest(route: Route, method: Method, parameters: [String: Any]? = nil) -> URLRequest? {
        let urlString = Route.baseUrl + route.description
        guard let url = urlString.asURL else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method {
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map { URLQueryItem(name: $0 , value: "\($1)") }
                urlRequest.url = urlComponent?.url
            case .post,.delete,.patch:
                let bodyData = try?
                JSONSerialization.data(withJSONObject:  params,options: [])
                urlRequest.httpBody = bodyData
            }
        }
        return urlRequest
    }
}

extension NetworkService: RemoteAPI {
    func fetchCategories(completion: @escaping (Result<AllDishes, Error>) -> Void) {
        performHTTPRequest(route: .fetchAllCategories, method: .get, completion: completion)
    }
    
    func placeOrder(dishId: String, name: String, completion: @escaping (Result<Order, Error>) -> Void) {
        let params = ["name": name]
        performHTTPRequest(route: .placeOrder(dishId), method: .post, parameters: params, completion: completion)
    }
    
    func fetchCategoryDishes(categoryId: String, completion: @escaping (Result<[Dish], Error>) -> Void) {
        performHTTPRequest(route: .fetchCategoryDishes(categoryId), method: .get, completion: completion)
    }
    
    func fetchOrders(completion: @escaping (Result<[Order], Error>) -> Void) {
        performHTTPRequest(route: .fetchOrders, method: .get, completion: completion)
    }
}
