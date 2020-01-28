//
//  BlockListItem.swift
//  Pepper
//
//  Created by Daniel Bernal on 18/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

struct Rule: Codable {
    let trigger: Trigger
    let action: Action
}
