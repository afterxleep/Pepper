//
//  DataSource.swift
//  Pepper
//
//  Created by Daniel Bernal on 22/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

enum ExceptionDataSourceError: Error {
    case recordExists
    case couldNotSaveRules
    case invalidDomain
}

protocol ExceptionDataSource {
    typealias ExceptionDataSourceCompletion<T> = (Result<Bool, ExceptionDataSourceError>) -> Void
    func totalRules() -> Int
    func rule(atIndex index: IndexPath) -> String?
    func addRule(domain: String, completion: @escaping ExceptionDataSourceCompletion<Bool>)
    func removeRule(atIndex index: Int, completion: @escaping (Bool) -> Void)
}
