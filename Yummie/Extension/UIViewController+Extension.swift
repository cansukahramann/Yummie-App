//
//  UIViewController+Extension.swift
//  Yummie
//
//  Created by Cansu Kahraman on 15.08.2023.
//

import UIKit

extension UIViewController {
    
    static var identifier: String{
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return
            storyboard
            .instantiateViewController(identifier: identifier) as! Self
    }
}
