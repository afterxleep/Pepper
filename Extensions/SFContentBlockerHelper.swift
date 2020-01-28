//
//  SFContentBlockerHelper.swift
//  Pepper
//
//  Created by Daniel Bernal on 22/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation
import SafariServices

enum SFHelperError: Error {
    case cannotUpdateContentBlocker
    case cannotUpdateRules
    case contentBlockerGeneralError
}

typealias SFCBHelperCompletion<T> = (Result<T, SFHelperError>) -> Void

class SFCBHelper {
    
    let contentBlockerIdentifier = Constants.ContentBlocker.contentBlockerIdentifier.rawValue
    
    func getContentBlockerStatus(completion: @escaping SFCBHelperCompletion<Bool>) {
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerIdentifier, completionHandler: { (state, error) in
            if error != nil {
                completion(.failure(.contentBlockerGeneralError))
            }
            if let state = state {
                let contentBlockerIsEnabled = state.isEnabled
                completion(.success(contentBlockerIsEnabled))
            }
        })
    }
    
    func reloadContentBlocker(completion: @escaping SFCBHelperCompletion<Bool>) {
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: "co.danielbernal.Pepper.ContentBlockerExtension") { (error) in
            if error != nil {
                print("-- Error: Could not update content blocker (Wrong JSON or Path???) \(String(describing: error))")
                completion(.failure(.cannotUpdateContentBlocker))
            } else {
                print("-- Content Blocker Update Succesfully")
                completion(.success(true))
            }
        }
    }
}
