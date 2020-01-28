//
//  ExceptionsCoordinator.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

protocol ExceptionsCoordinatorDelegate: class {
    func exceptionsCoordinatorDidFinish(coordinator: Coordinator)
}

class ExceptionsCoordinator: Coordinator {
    weak var delegate: ExceptionsCoordinatorDelegate?
    
    internal let storyBoard = Constants.Storyboards.exceptionsStoryBoard.rawValue
    internal var navigationController: UINavigationController
    internal var childCoordinators: [Coordinator]
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    internal func start() {
        let vc = ExceptionsViewController.instatiate(fromStoryboard: storyBoard)
        vc.delegate = self
        
        // Dependencies
        let whitelist = UserWhiteList(listStore: FileListStore(), networkClient: nil)
        let presenter = ExceptionsPresenter(rulesList: whitelist)
        
        vc.presenter = presenter
        navigationController.pushViewController(vc, animated: true)
    }
    
}

extension ExceptionsCoordinator: ExceptionsViewControllerDelegate {
    
    func exceptionsViewControllerViewDidAppear() {}
    
    func exceptionsViewControllerViewDidDisappear() {
        delegate?.exceptionsCoordinatorDidFinish(coordinator: self)
    }
    
}
