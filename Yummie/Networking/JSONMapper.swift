//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

struct JSONMapper {
    private init() {
        // `JSONMapper` is just a namespace and holds nothing
    }
    
    static func map<T: Decodable>(data: Data, completion: (Result<T, Error>) -> Void) {
        let decoder = JSONDecoder()
        guard let response = try? decoder.decode(ApiResponse<T>.self, from: data) else {
            return completion(.failure(AppError.errorDecoding))
        }
        if let error = response.error {
            completion(.failure(AppError.serverError(error)))
        }
        else if let decodeedData = response.data {
            completion(.success(decodeedData))
        }
        else {
            completion(.failure(AppError.unknownError))
        }
    }
}
