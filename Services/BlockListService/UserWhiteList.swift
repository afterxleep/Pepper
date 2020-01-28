//
//  EasyListParser.swift
//  Pepper
//
//  Created by Daniel Bernal on 18/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

struct UserWhiteList: BlockListService {
        
    var identifier: String = BlockLists.UserWhitelist.identifier.rawValue
    private let listStore: StorageService
    
    init(listStore: StorageService, networkClient: NetworkClientService?) {
        self.listStore = listStore
    }
    
    func create(completion: @escaping BlockListServiceCompletion<Bool>) {
        
        let rules: [Rule] = []
        guard let encodedData = try? JSONEncoder().encode(rules) else {
            completion(.failure(.cannotEncodeData))
            return
        }
                           
        self.listStore.write(path: self.identifier, data: encodedData) { writeResult in
           switch writeResult {
           case .success:
               completion(.success(true))
               
           case .failure:
               completion(.failure(.cannotWriteData))
           }
        }
    }
      
    func read(completion: @escaping BlockListServiceCompletion<[Rule]>) {
        
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
    
    func replace(withData data: [Rule], completion: @escaping Self.BlockListServiceCompletion<Bool>) {
           
         guard let encodedData = try? JSONEncoder().encode(data) else {
            completion(.failure(.cannotEncodeData))
            return
        }
        
        self.listStore.write(path: self.identifier, data: encodedData) { writeResult in
            switch writeResult {
            case .success:
                completion(.success(true))
            case .failure:
                completion(.failure(.cannotWriteData))
            }
        }
    }
    
    func update(completion: @escaping BlockListServiceCompletion<Bool>) {
        //sleep(10)
        completion(.success(true))
    }

}
