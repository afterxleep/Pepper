//
//  MainView.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

enum MainViewError: Error {
    case errorUpdatingRules
    case genericError
}

protocol MainView {
    func toggleButtons()
    func updateTrackersCount()
    func notifyUpdateCompleted()
    func notifyUpdateError(error: MainViewError)
    func validateContentBlockerStatus()
    func configureUI()
}
