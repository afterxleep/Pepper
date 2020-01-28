//
//  MainCoordinator.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

protocol MainCoordinatorDelegate: class {}

class MainCoordinator: Coordinator {
    
    weak var delegate: MainCoordinatorDelegate?
    
    internal let storyBoard = Constants.Storyboards.mainStoryBoard.rawValue
    internal var navigationController: UINavigationController
    internal var childCoordinators: [Coordinator]
    internal var presenter: MainPresenter?
    internal var contentBlockerManager: ContentBlockerManager?
    internal var exceptionsCoordinator: ExceptionsCoordinator?
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    internal func start() {
        let vc = MainViewController.instatiate(fromStoryboard: storyBoard)
        vc.delegate = self
        
        //Dependencies
        let contentBlockerHelper = SFCBHelper()
        let contentBlocker = getContentBlocker(contentBlockerHelper: contentBlockerHelper)
        presenter = MainPresenter(contentBlockerManager: contentBlocker, contentBlockerHelper: contentBlockerHelper)
        vc.presenter = presenter
        navigationController.pushViewController(vc, animated: false)
    }
    
    internal func displayExceptions() {
        let coordinator = ExceptionsCoordinator(with: navigationController)
        exceptionsCoordinator = coordinator
        addChild(coordinator: coordinator)
        exceptionsCoordinator?.delegate = self
        exceptionsCoordinator?.start()
    }
    
}

// MARK: ContentBlocker Setup
// List registration and initialization happens here
extension MainCoordinator {
    
    func getContentBlocker(contentBlockerHelper: SFCBHelper) -> ContentBlockerManager {
        // List Management Dependencies
        let fileStorage = FileListStore()
        let networkClient = NetworkClient()
        
        // Lists container (Register additional blocklists here)
        let listContainer = ListContainer()
        let easylist = EasyList(listStore: fileStorage, networkClient: networkClient)
        let userWhitelist = UserWhiteList(listStore: fileStorage, networkClient: nil)
        
        // Create the Blocklists on first launch
        if !UserDefaults.standard.bool(forKey: Constants.UserDefaultsKeys.appHasLaunched.rawValue) {
            easylist.create { _ in }
            userWhitelist.create { _ in }
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKeys.appHasLaunched.rawValue)
        }
        
        // Add the lists to the container
        listContainer.add(blockList: easylist)
        listContainer.add(blockList: userWhitelist)

        // Content blocker manager
        return ContentBlockerManager(listContainer: listContainer, contentBlockerHelper: contentBlockerHelper)
    }
    
}

// MARK: MainViewControllerDelegate
extension MainCoordinator: MainViewControllerDelegate {
    
    func mainViewControllerViewDidAppear() {}
    func mainViewControllerViewDidDissapear() {}
    func mainViewControllerDidTapExceptionBtn() {
        displayExceptions()
    }
}

// MARK: ExceptionsCoordinator Delegate
extension MainCoordinator: ExceptionsCoordinatorDelegate {
    
    func exceptionsCoordinatorDidFinish(coordinator: Coordinator) {
        removeChild(coordinator: coordinator)
        // Update the content blocker silently
        contentBlockerManager?.performUpdate(completion: { (_) in })        
    }
}
