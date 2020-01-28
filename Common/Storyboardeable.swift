//
//  Storyboardeable.swift
//  Pepper
//
//  Created by Daniel Bernal on 21/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboardeable {
    static func instatiate(fromStoryboard: String) -> Self
}

extension Storyboardeable where Self: UIViewController {
    
    static func instatiate(fromStoryboard: String) -> Self {
        let name = NSStringFromClass(self)
        let className = name.components(separatedBy: ".")[1] // Project.className
        let storyboard = UIStoryboard(name: fromStoryboard, bundle: Bundle.main)
        return (storyboard.instantiateViewController(withIdentifier: className) as? Self)!
       }
}
