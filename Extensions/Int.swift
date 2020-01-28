//
//  Int+Numberformatted.swift
//  Pepper
//
//  Created by Daniel Bernal on 22/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

extension Int {
    func formatted() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
