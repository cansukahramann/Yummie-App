//
//  AppError.swift
//  Yummie
//
//  Created by Cansu Kahraman on 18.08.2023.
//

import Foundation

enum AppError: LocalizedError{
    case errorDecoding
    case unknownError
    case invalidUrl
    case serverError(String)
    
    
    var errorDescription: String?{
        switch self {
        case.errorDecoding:
            return "response could not be decoding"
        case.unknownError:
            return "Bruhh!!! I have no idea whats go on "
        case.invalidUrl:
            return "Hey!! Give me a valid URL"
        case.serverError(let error):
            return error
        }
    }
    
}
