//
//  ListParser.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

enum BlockListError: Error {
    case cannotDecodeData
    case cannotReadData
    case cannotWriteData
    case cannotEncodeData
    case cannotRetrieveUpdate
    case missingFilterId    
    case networkClientNotPresent
    case cannotCreateList
    case invalidURL
}

protocol BlockListService {
    typealias BlockListServiceCompletion<T> = (Result<T, BlockListError>) -> Void
    var identifier: String { get }
    init(listStore: StorageService, networkClient: NetworkClientService?)
    func read(completion: @escaping  BlockListServiceCompletion<[Rule]>)
    func create(completion: @escaping  BlockListServiceCompletion<Bool>)
    func update(completion: @escaping BlockListServiceCompletion<Bool>)
    func replace(withData data: [Rule], completion: @escaping BlockListServiceCompletion<Bool>)
}
