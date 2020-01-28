//
//  NetworkClient.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum RequestError: Error {
    case unableToMakeRequest
    case requestFailed
    case notFound
    case serverError
    case forbidden
    case emptyResponse
    case other
}

protocol NetworkClientService {
    typealias NetworkClientServiceResponse<T> = (Result<Data, RequestError>) -> Void
    func sendRequest(method: HTTPMethod, url: URL, completion: @escaping NetworkClientServiceResponse<Data>)
}
