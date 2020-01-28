//
//  FileStore.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

struct FileListStore: StorageService {
          
    private let fileManager = FileManager.default    
    
    private enum FileError: Error {
        case fileURLisInvalid
        case fileDoesNotExist
        case cannotReadFile
        case cannotEncodeData
        case cannotWriteFile        
    }

    // MARK: StorageService
    
    func read(path: String, completion: @escaping StorageServiceCompletion<Data>) {
        
        guard let fileURL = fileManager.documentsPath?.appendingPathComponent(path) else {
            completion(.failure(FileError.fileURLisInvalid))
            return
        }
        if !fileManager.fileExists(atPath: fileURL.path) {
            completion(.failure(FileError.fileDoesNotExist))
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            completion(.success(data))
        } catch {
            completion(.failure(FileError.cannotReadFile))
        }
    }
    
    func write(path: String, data: Data, completion: @escaping StorageServiceCompletion<Bool>) {
        guard let fileURL = fileManager.documentsPath?.appendingPathComponent(path) else {
            completion(.failure(FileError.fileURLisInvalid))
            return
        }
                
        do {
            try data.write(to: fileURL, options: .atomic)
            completion(.success(true))
        } catch {
            completion(.failure(FileError.cannotWriteFile))
        }
    }
}
