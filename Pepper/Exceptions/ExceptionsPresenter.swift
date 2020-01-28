//
//  ExceptionsPresenter.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

class ExceptionsPresenter: BasePresenter {
    
    typealias View = ExceptionsView
    private var exceptionsView: ExceptionsView?
    let rulesList: BlockListService
    var rules = [Rule]()
    
    let domainRegex = "[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = "SELF MATCHES %@"
    let rulePreffix = "^https?://.*"
    let resourceTypes = ["image",
                        "style-sheet",
                        "script",
                        "font",
                        "media",
                        "raw"
                        ]
    let actionType = "ignore-previous-rules"
    let wildcard = #"\*"#
    
    func attachView(view: ExceptionsView) {
        exceptionsView = view
        loadData()
    }
        
    func detachView() {
        exceptionsView = nil
    }
        
    func destroy() {            
    }
    
    init(rulesList: BlockListService) {
        self.rulesList = rulesList
    }
    
    func isValidDomain(domain: String) -> Bool {
        let emailRegEx = domainRegex
        let emailPred = NSPredicate(format: emailPredicate, emailRegEx)
        return emailPred.evaluate(with: domain)
    }

}

extension ExceptionsPresenter: ExceptionDataSource {

    func loadData() {
        rulesList.read(completion: { (result) in
            switch result {
            case .success(let data):
                self.rules = data
                
            case .failure:
                print("Error loading Rules")
            }
        })
    }
    
    func totalRules() -> Int {
         return rules.count
    }
    
    func rule(atIndex index: IndexPath) -> String? {
         if index.row < rules.count {
            return getDomainNameFromFilterString(filter: rules[index.row].trigger.urlFilter)
        }
        return nil
    }
    
    func addRule(domain: String, completion: @escaping ExceptionDataSourceCompletion<Bool>) {
        
        let rule = generateWhitelistRuleFor(domain: domain)
        let exists = rules.contains { $0.trigger.urlFilter == rule.trigger.urlFilter }
        
        if !isValidDomain(domain: domain) {
            completion(.failure(.invalidDomain))
            return
        }
        
        if !exists {
            rules.append(generateWhitelistRuleFor(domain: domain))
            rulesList.replace(withData: rules) { (saveResult) in
                switch saveResult {
                case .success:
                    completion(.success(true))
                case .failure:
                    completion(.failure(.couldNotSaveRules))
                }
            }
        } else {
            completion(.failure(.recordExists))
        }
        
    }
    
    func removeRule(atIndex index: Int, completion: @escaping (Bool) -> Void) {
        
        rules.remove(at: index)
        rulesList.replace(withData: rules) { (result) in
            if case .success = result {                
                completion(true)
            } else {
                completion(false)
            }
            
        }
    }
    
    // MARK: Utility Methods
    
    func generateWhitelistRuleFor(domain: String) -> Rule {
        let preffix = rulePreffix
        let domain = domain.replacingOccurrences(of: ".", with: "\\.")
        let action = Action(type: actionType)
        let trigger = Trigger(urlFilter: "\(preffix)\(domain)",
                              resourceType: resourceTypes,
                              loadType: nil,
                              urlFilterIsCaseSensitive: true,
                              ifDomain: ["\(wildcard)\(domain)"],
                              unlessDomain: nil,
                              ifTopURL: nil,
                              unlessTopURL: nil)
        return Rule(trigger: trigger, action: action)        
    }
    
    func getDomainNameFromFilterString(filter: String) -> String {
        let preffix = rulePreffix
        let domain = filter.replacingOccurrences(of: preffix, with: "")
        return domain.replacingOccurrences(of: "\\", with: "")
    }
}
