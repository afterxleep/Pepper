//
//  FileStore.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

class DummyStorage: StorageService {
        
    private enum DummyListError: Error {
        case fileNotFound
        case cannotReadFile
    }
    
    let filetype = "json"
    
    func read(path: String, completion: @escaping StorageServiceCompletion<Data>) {
        
        sleep(2)
        
        let bundle = Bundle(for: type(of: self))
        if let filePath = bundle.path(forResource: path, ofType: filetype) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                completion(.success(data))
            } catch {
                completion(.failure(DummyListError.cannotReadFile))
            }
        } else {
            completion(.failure(DummyListError.fileNotFound))
        }
    }
    
    func write(path: String, data: Data, completion: @escaping StorageServiceCompletion<Bool>) {
        completion(.success(true))
    }
}
