//
//  OnboardView.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

enum ExceptionViewError: Error {
    case recordExists    
}

protocol ExceptionsView {
    func addRule(domain: String)
    func notifyAddRuleError(message: ErrorAlert)
    func resetForm()
    func configureUI()
}
