//
//  DummyList.swift
//  Pepper
//
//  Created by Daniel Bernal on 18/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

struct DummyList: BlockListService {
    
    var identifier = BlockLists.DummyList.identifier.rawValue
    private let listStore: StorageService    
    
    init(listStore: StorageService, networkClient: NetworkClientService?) {
        self.listStore = listStore
    }
    
    func create(completion: @escaping BlockListServiceCompletion<Bool>) {
        completion(.success(true))        
    }
      
    func read(completion: @escaping BlockListServiceCompletion<[Rule]>) {
        
        sleep(2)
        
        listStore.read(path: identifier) { readResult in
            switch readResult {
            case .success(let resultData):
                guard let listData = try? JSONDecoder().decode([Rule].self, from: resultData) else {
                    completion(.failure(.cannotDecodeData))
                    return
                }
                completion(.success(listData))
            case .failure:
                completion(.failure(.cannotReadData))
            }
        }
    }
    
    func update(completion: @escaping Self.BlockListServiceCompletion<Bool>) {
        completion(.success(true))
    }
    
    func replace(withData data: [Rule], completion: @escaping Self.BlockListServiceCompletion<Bool>) {
        completion(.success(true))
    }
}
