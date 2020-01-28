//
//  URLSessionHelpers.swift
//  Pepper
//
//  Created by Daniel Bernal on 19/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

extension URLSession {
    
    // Using result types with dataTask
    func dataTask(with url: URL, completionHandler: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url, completionHandler: { (data, urlResponse, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data, let urlResponse = urlResponse as? HTTPURLResponse {
                completionHandler(.success((data, urlResponse)))
            }
        })
    }
}
