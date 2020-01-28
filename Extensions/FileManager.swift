//
//  FileManager+DocumentsPath.swift
//  Pepper
//
//  Created by Daniel Bernal on 18/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

extension FileManager {
    
    var documentsPath: URL? {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsDirectory = paths.first else { return nil }
        return documentsDirectory
    }
    
}
