//
//  DummyNetworkClient.swift
//  Pepper
//
//  Created by Daniel Bernal on 21/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

enum DummyRequestType {
    case JSONList
}

class DummyNetworkClient: NetworkClientService {
    
    private let requestType: DummyRequestType
    private let fileManager = FileManager.default
    private let dummyJSONDataPath = BlockLists.DummyList.identifier.rawValue
    
    init(requestType: DummyRequestType) {
        self.requestType = requestType
    }
    
    func sendRequest(method: HTTPMethod, url: URL, completion: @escaping NetworkClientServiceResponse<Data>) {
        
        switch requestType {
        case .JSONList:
            
            let bundle = Bundle(for: type(of: self))
            if let filePath = bundle.path(forResource: dummyJSONDataPath, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                    completion(.success(data))
                } catch {
                    completion(.failure(.requestFailed))
                }
            } else {
                completion(.failure(.requestFailed))
            }
        }
    }
    
}
