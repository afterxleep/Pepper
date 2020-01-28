//
//  EasyListParser.swift
//  Pepper
//
//  Created by Daniel Bernal on 18/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

struct EasyList: BlockListService {

    var identifier: String = BlockLists.EasyList.identifier.rawValue
    private let updateURL: String = BlockLists.EasyList.updateURL.rawValue
    
    let listStore: StorageService
    let networkClient: NetworkClientService?
    var listData: [Rule] = []
    
    init(listStore: StorageService, networkClient: NetworkClientService?) {
        self.listStore = listStore
        self.networkClient = networkClient
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
    
    func update(completion: @escaping BlockListServiceCompletion<Bool>) {
        
        guard let netClient = networkClient else {
            print("Network Client not present")
            completion(.failure(.networkClientNotPresent))
            return
        }
        
        guard let downloadURL = URL(string: updateURL) else {
            print("Invalid URL")
            completion(.failure(.invalidURL))
            return
        }
        
        netClient.sendRequest(method: HTTPMethod.get, url: downloadURL) { requestResult in
            switch requestResult {
            case .success(let downloadedData):
                    
                    self.listStore.write(path: self.identifier, data: downloadedData) { writeResult in
                        switch writeResult {
                        case .success:
                            print("Easylist downloaded correctly")
                            completion(.success(true))
                        case .failure:
                            completion(.failure(.cannotWriteData))
                        }
                    }
            case .failure:
                  completion(.failure(.cannotRetrieveUpdate))
            }
        }
    }
    
    func replace(withData data: [Rule], completion: @escaping Self.BlockListServiceCompletion<Bool>) {
        completion(.success(true))
    }
}
