//
//  MainDataSource.swift
//  Pepper
//
//  Created by Daniel Bernal on 22/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

protocol MainDataSource {
    func totalTrackers() -> String
    func contentBlockerStatus() -> Bool
}
