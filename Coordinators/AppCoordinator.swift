//
//  AppCoordinator.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    private var window: UIWindow
    internal var navigationController: UINavigationController
    internal var childCoordinators: [Coordinator]
    
    let tintColor = UIColor.white
    let largeTitle = false
    let titleColor = UIColor.white
    let bgColor = UIColor(red: 82/255, green: 162/255, blue: 246/255, alpha: 1)
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    init(in window: UIWindow) {
        self.childCoordinators = []
        self.navigationController = UINavigationController()
        
        self.window = window
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        configureUI()
        if UserDefaults.standard.bool(forKey: Constants.UserDefaultsKeys.isBlockerExtensionActive.rawValue) {
            displayMain()
        } else {
            displayOnboard()
        }
    }
    
    func displayMain() {
        let mainCoordinator = MainCoordinator(with: navigationController)
        addChild(coordinator: mainCoordinator)
        mainCoordinator.start()
    }
    
    func displayOnboard() {
        let onboardCoordinator = OnboardCoordinator(with: navigationController)
        addChild(coordinator: onboardCoordinator)
        onboardCoordinator.start()
        onboardCoordinator.delegate = self
    }
    
    func configureUI() {
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.tintColor = tintColor
        navigationController.navigationBar.barTintColor = bgColor
        navigationController.navigationBar.prefersLargeTitles = largeTitle
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
    }
    
}

extension AppCoordinator: MainCoordinatorDelegate {}

extension AppCoordinator: OnboardCoordinatorDelegate {
    
    func didCompleteOnboarding(coordinator: OnboardCoordinator) {
        displayMain()
        removeChild(coordinator: coordinator)
    }
}
