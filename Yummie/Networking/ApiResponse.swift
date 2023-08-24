//
//  ApiResponse.swift
//  Yummie
//
//  Created by Cansu Kahraman on 21.08.2023.
//

import UIKit


struct ApiResponse<T: Decodable>: Decodable{
    let status: Int
    let message: String?
    let data: T?
    let error: String?
    
}
