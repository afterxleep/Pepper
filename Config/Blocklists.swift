//
//  Blocklists.swift
//  Pepper
//
//  Created by Daniel Bernal on 22/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//
enum BlockLists {
    
    enum EasyList: String {
        case identifier = "EasyList"
        case updateURL = "https://danielbernal.co/pepper/easyprivacy.json"
    }
    enum UserWhitelist: String {
        case identifier = "UserWhiteList"
    }
    enum DummyList: String {
        case identifier = "SampleBlockList"
    }
}
