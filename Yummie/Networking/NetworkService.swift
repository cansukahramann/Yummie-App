//
//  NetworkingService.swift
//  Yummie
//
//  Created by Cansu Kahraman on 18.08.2023.
//

import Foundation

protocol RemoteAPI {
    func fetchCategories(completion: @escaping (Result<AllDishes, Error>) -> Void)
    func placeOrder(dishId: String, name: String, completion: @escaping (Result<Order, Error>) -> Void)
    func fetchCategoryDishes(categoryId: String, completion: @escaping (Result<[Dish], Error>) -> Void)
    func fetchOrders(completion: @escaping (Result<[Order], Error>) -> Void)
}

class NetworkService {
    
    #warning("remove shared instance (Singleton pattern)")
    static let shared = NetworkService()
    
    private init () {}
    
    private var currentTask: URLSessionDataTask?
    
    private func request<T: Decodable>(route: Route, method: Method, parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        guard let request = createRequest(route: route, method: method, parameters: parameters) else {
            completion(.failure(AppError.unknownError))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            var result: Result<Data, Error>?
            if let data = data {
                result = .success(data)
                let responseString = String(data: data, encoding: .utf8) ?? "Could not stringify our data"
            } else if let error = error {
                result = .failure(error)
            }
            #warning("remove dispatching into main thread, since this is not the network layer's responsibility")
            DispatchQueue.main.async {
                self.handleResponse(result: result, completion: completion)
            }
        }
        task.resume()
        
        return task
    }
    
    private func handleResponse<T: Decodable>(result: Result<Data, Error>?, completion: (Result<T, Error>) -> Void) {
        guard let result = result else {
            completion(.failure(AppError.unknownError))
            return
        }
        
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            guard let response = try?
                    decoder.decode(ApiResponse<T>.self, from: data) else {
                completion(.failure(AppError.errorDecoding))
                return
            }
            
            if let error = response.error {
                completion(.failure(AppError.serverError(error)))
                return
            }
            
            if let decodeedData = response.data {
                completion(.success(decodeedData))
            } else {
                completion(.failure(AppError.unknownError))
            }
            
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func createRequest(route: Route, method: Method, parameters: [String: Any]? = nil) -> URLRequest? {
        let urlString = Route.baseUrl + route.description
        guard let url = urlString.asURL else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method{
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map { URLQueryItem(name: $0 , value: "\($1)")}
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
    func fetchCategories(completion: @escaping(Result<AllDishes,Error>) -> Void) {
        currentTask = request(route: .fetchAllCategories, method: .get, completion: completion)
    }
    func placeOrder(dishId: String, name: String,completion: @escaping (Result<Order,Error>) -> Void) {
        let params = ["name": name]
        currentTask = request(route: .placeOrder(dishId), method: .post, parameters: params, completion: completion)
    }
    func fetchCategoryDishes(categoryId: String, completion: @escaping(Result<[Dish],Error>) -> Void) {
        currentTask = request(route: .fetchCategoryDishes(categoryId), method: .get, completion: completion)
    }
    func fetchOrders(completion: @escaping(Result<[Order],Error>) -> Void) {
        currentTask = request(route: .fetchOrders, method: .get,completion: completion)
    }
}
