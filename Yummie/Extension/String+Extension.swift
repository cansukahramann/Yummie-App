//
//  String+Extension.swift
//  Yummie
//
//  Created by Cansu Kahraman on 11.08.2023.
//

import Foundation

extension String{
    var asURL: URL?{
        return URL(string: self)
    }
}
