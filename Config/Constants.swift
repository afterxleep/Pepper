//
//  Constants.swift
//  Pepper
//
//  Created by Daniel Bernal on 21/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

enum Constants {
    
    enum UserDefaultsKeys: String {
        case appHasLaunched
        case isBlockerExtensionActive
        case totalTrackersBlocked
    }
    
    enum Storyboards: String {
        case mainStoryBoard = "Main"
        case onboardStoryBoard = "Onboard"
        case exceptionsStoryBoard = "Exceptions"
    }
    
    enum ContentBlocker: String {
        case sharedContainerName = "group.co.danielbernal.Pepper"
        case contentBlockerIdentifier = "co.danielbernal.Pepper.ContentBlockerExtension"
        case outputFileName = "blockList.json"
    }
    
    enum NotificationsKeys {
        case appWillAppear
    }
}
