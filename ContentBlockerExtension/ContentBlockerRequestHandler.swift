//
//  ContentBlockerRequestHandler.swift
//  ContentBlockerExtension
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    
    let sharedContainerName = Constants.ContentBlocker.sharedContainerName.rawValue
    let contentBlockerIdentifier = Constants.ContentBlocker.contentBlockerIdentifier
    let inputFileName = Constants.ContentBlocker.outputFileName.rawValue
    
    func beginRequest(with context: NSExtensionContext) {
        let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: sharedContainerName)
        let sourceURL = sharedContainerURL?.appendingPathComponent(inputFileName)
        let ruleAttachment = NSItemProvider(contentsOf: sourceURL)
        let item = NSExtensionItem()
        item.attachments = ([ruleAttachment] as? [NSItemProvider])
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
}
