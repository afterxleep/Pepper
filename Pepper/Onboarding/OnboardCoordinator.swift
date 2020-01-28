//
//  OnboardCoordinator.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation
import UIKit

protocol OnboardCoordinatorDelegate: class {
    func didCompleteOnboarding(coordinator: OnboardCoordinator)
}

class OnboardCoordinator: Coordinator {
    weak var delegate: OnboardCoordinatorDelegate?
    
    internal let storyBoard = Constants.Storyboards.onboardStoryBoard.rawValue
    internal var navigationController: UINavigationController
    internal var childCoordinators: [Coordinator]
    internal var paginationController: OnboardViewController?
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }

    internal func start() {
        let presenter = OnboardPresenter(contentBlockerHelper: SFCBHelper())
        let vc = OnboardViewController.instatiate(fromStoryboard: storyBoard)
        vc.coDdelegate = self
        vc.presenter = presenter
        paginationController = vc
        
        // Onboarding ViewController
        let page1vc = OnboardFirstViewController.instatiate(fromStoryboard: storyBoard)
        page1vc.delegate = self
        page1vc.presenter = presenter
        
        let page2vc = OnboardSecondViewController.instatiate(fromStoryboard: storyBoard)
        page2vc.delegate = self
        page2vc.presenter = presenter
        
        let page3vc = OnboardThirdViewController.instatiate(fromStoryboard: storyBoard)
        page3vc.delegate = self
        page3vc.presenter = presenter
        
        let page4vc = OnboardFourthViewController.instatiate(fromStoryboard: storyBoard)
        page4vc.delegate = self
        page4vc.presenter = presenter
        
        // Set the viewcontrollers for the PaginatedView
        vc.onboardControllers = [page1vc, page2vc, page3vc, page4vc]
        
        navigationController.pushViewController(vc, animated: false)
    }
    
}

extension OnboardCoordinator: OnboardViewControllerDelegate {
    func onboardViewControllerViewDidAppear() {}
    
    func onBoardDidTapFinalButton() {
        delegate?.didCompleteOnboarding(coordinator: self)
    }
    
    func onboardDidTapNextButton(index: Int) {
               
        guard let secondViewcontroller = paginationController?.onboardControllers[index] else { return }
        paginationController?.setViewControllers(
            [secondViewcontroller],
            direction: .forward,
            animated: true,
            completion: nil)
    }

}
