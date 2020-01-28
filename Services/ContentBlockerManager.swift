//
//  ContentBlockerService.swift
//  Pepper
//
//  Created by Daniel Bernal on 19/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

enum ContentBlockerError: Error {
    case cannotSaveRuleset
    case cannotReadRuleSet
    case cannotEncodeRuleSet
    case cannotFindDestinationURL
    case cannotUpdateRules
    case cannotUpdateContentBlocker
}

struct ContentBlockerManager {
    
    let listContainer: ListContainer
    let contentBlockerHelper: SFCBHelper
    let sharedContainerName = Constants.ContentBlocker.sharedContainerName.rawValue
    let outputFileName = Constants.ContentBlocker.outputFileName.rawValue
    typealias ContentBlockerCompletion<T> = (Result<T, ContentBlockerError>) -> Void
    
    init(listContainer: ListContainer, contentBlockerHelper: SFCBHelper) {
        self.listContainer = listContainer
        self.contentBlockerHelper = contentBlockerHelper
    }
    
    func performUpdate(completion: @escaping ContentBlockerCompletion<Int>) {
        updateLists { (result) in
            switch result {
            case .success:
                self.updateExtension { (result) in
                    switch result {
                    case .success(let trackerCount):
                        completion(.success(trackerCount))
                    case .failure:
                        completion(.failure(.cannotUpdateRules))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func updateLists(completion: @escaping ContentBlockerCompletion<Bool>) {        
        
        var updateFailures = false
        let dispatchQueue = DispatchQueue(label: "dispatchQueue", qos: .userInitiated)
        let dispatchGroup = DispatchGroup.init()
        for blockList in listContainer.blockLists {
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                print("Updating \(blockList.identifier)")
                 blockList.update { (result) in
                    switch result {
                    case .success:
                        print("\(blockList.identifier) Updated successfully")
                        dispatchGroup.leave()
                    case .failure:
                        print("\(blockList.identifier) Update failed")
                        updateFailures = true
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.wait(timeout: DispatchTime.distantFuture)
        if updateFailures {
            completion(.failure(.cannotUpdateRules))
        } else {
            completion(.success(true))
        }
    }
    
    func consolidateRules(completion: @escaping ContentBlockerCompletion<[Rule]>) {
        var rules: [Rule] = []
    
        print("Consolidating Rules")
        for blockList in listContainer.blockLists {
                blockList.read { (result) in
                    switch result {
                    case .success(let data):
                        print("\(blockList.identifier) Added")
                        rules += data                        
                    case .failure:
                        completion(.failure(.cannotReadRuleSet))
                    }
                }
        }
        completion(.success(rules))
    }
    
    func saveRulesToContainer(rules: [Rule]) throws {
        
        let encoder = JSONEncoder()
        //encoder.outputFormatting = [.prettyPrinted]
        guard let encoded = try? encoder.encode(rules) else {
            throw ContentBlockerError.cannotEncodeRuleSet
        }
        let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: sharedContainerName)        
        guard let destinationURL = sharedContainerURL?.appendingPathComponent(outputFileName) else {
            throw ContentBlockerError.cannotFindDestinationURL
        }
        do {
            try encoded.write(to: destinationURL)
            print(destinationURL)
        } catch {
            throw ContentBlockerError.cannotSaveRuleset
        }
    }
    
    func updateExtension(completion: @escaping ContentBlockerCompletion<Int>) {
        
        print("Consolidating Block Lists")
        consolidateRules { (consolidateResult) in
            
            switch consolidateResult {
            case .success(let data):
                do {
                    print("Updating Content Blocker")
                    try self.saveRulesToContainer(rules: data)
                    self.contentBlockerHelper.reloadContentBlocker { (result) in
                        switch result {
                        case .success:
                            completion(.success(data.count))
                            UserDefaults.standard.set(data.count, forKey: Constants.UserDefaultsKeys.totalTrackersBlocked.rawValue)
                        case .failure:
                            completion(.failure(.cannotUpdateContentBlocker))
                        }
                    }
                } catch {
                    print("-- Error: Cannot Save Rules")
                    completion(.failure(.cannotSaveRuleset))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
