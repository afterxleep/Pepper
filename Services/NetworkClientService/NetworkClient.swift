//
//  NetworkClient.swift
//  Pepper
//
//  Created by Daniel Bernal on 19/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

struct NetworkClient: NetworkClientService {
       
    func sendRequest(method: HTTPMethod, url: URL, completion: @escaping NetworkClientServiceResponse<Data>) {
        
        URLSession.shared.dataTask(with: url) { result in
            switch result {
            case .success(let data, let urlResponse):                
                switch urlResponse.statusCode {
                case 403:
                    completion(.failure(.forbidden))
                    return
                case 404:
                    completion(.failure(.notFound))
                    return
                case 500...599:
                    completion(.failure(.serverError))
                case 200...299:
                    completion(.success(data))
                default:
                    completion(.failure(.other))
                    return
                }
            case .failure:
                completion(.failure(.unableToMakeRequest))
            }
        }.resume()
        
    }
}
