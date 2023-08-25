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
    
    private func request(route: Route, method: Method, parameters: [String: Any]? = nil, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        guard let request = createRequest(route: route, method: method, parameters: parameters) else {
            completion(.failure(AppError.unknownError))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
        
        return task
    }
    
    private func createRequest(route: Route, method: Method, parameters: [String: Any]? = nil) -> URLRequest? {
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
        currentTask = request(route: .fetchAllCategories, method: .get, completion: { result in
            switch result {
            case .success(let data):
                JSONMapper.map(data: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func placeOrder(dishId: String, name: String, completion: @escaping (Result<Order, Error>) -> Void) {
        let params = ["name": name]
        currentTask = request(route: .placeOrder(dishId), method: .post, parameters: params, completion: { result in
            switch result {
            case .success(let data):
                JSONMapper.map(data: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func fetchCategoryDishes(categoryId: String, completion: @escaping (Result<[Dish], Error>) -> Void) {
        currentTask = request(route: .fetchCategoryDishes(categoryId), method: .get, completion: { result in
            switch result {
            case .success(let data):
                JSONMapper.map(data: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func fetchOrders(completion: @escaping (Result<[Order], Error>) -> Void) {
        currentTask = request(route: .fetchOrders, method: .get,completion: { result in
            switch result {
            case .success(let data):
                JSONMapper.map(data: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
