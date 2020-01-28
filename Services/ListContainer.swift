//
//  ListContainer.swift
//  Pepper
//
//  Created by Daniel Bernal on 21/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

class ListContainer {
    var blockLists: [BlockListService] = []
    
    func add(blockList: BlockListService) {
        blockLists.append(blockList)
    }
    
    func removeAll() {
        blockLists.removeAll()
    }
}
