//
//  StorageService.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

protocol StorageService {
    typealias StorageServiceCompletion<T> = (Result<T, Error>) -> Void
    func read(path: String, completion: @escaping  StorageServiceCompletion<Data>)
    func write(path: String, data: Data, completion: @escaping  StorageServiceCompletion<Bool>)
}
