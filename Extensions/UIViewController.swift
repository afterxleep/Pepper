//
//  UIViewController.swift
//  Pepper
//
//  Created by Daniel Bernal on 23/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import UIKit

struct ErrorAlert {
    let title: String
    let text: String
    let button: String
}

extension UIViewController {

    func presentAlertWithMessage(message: ErrorAlert) {
        let alertController = UIAlertController(title: message.title,
                                                message: message.text,
                                                preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: message.button, style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
