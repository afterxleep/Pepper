//
//  Trigger.swift
//  Pepper
//
//  Created by Daniel Bernal on 18/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

struct Trigger: Codable {
    let urlFilter: String
    let resourceType: [String]
    var loadType: [String]?
    var urlFilterIsCaseSensitive: Bool?
    var ifDomain: [String]?
    var unlessDomain: [String]?
    var ifTopURL: [String]?
    var unlessTopURL: [String]?
    
    enum CodingKeys: String, CodingKey {
        case urlFilter = "url-filter"
        case resourceType = "resource-type"
        case urlFilterIsCaseSensitive = "url-filter-is-case-sensitive"
        case ifDomain = "if-domain"
        case unlessDomain = "unless-domain"
        case loadType = "load-type"
        case ifTopURL = "if-top-url"
        case unlessTopURL = "unless-top-url"
    }
}
