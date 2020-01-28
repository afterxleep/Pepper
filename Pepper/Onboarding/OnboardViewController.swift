//
//  OnboardViewController.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import UIKit

protocol OnboardViewControllerDelegate: class {
    func onboardViewControllerViewDidAppear()
    func onboardDidTapNextButton(index: Int)
    func onBoardDidTapFinalButton()
}

class OnboardViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, OnboardView, Storyboardeable {
    
    weak var coDdelegate: OnboardViewControllerDelegate?
    var presenter: OnboardPresenter?
    var onboardControllers: [UIViewController] = []
    var currentPage = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(view: self)
         // Disabled to force steps with buttons
        //self.dataSource = self
        self.delegate   = self
        if let firstVC = onboardControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coDdelegate?.onboardViewControllerViewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
    
extension OnboardViewController {
      func viewControllerAtIndex(_ index: Int) -> UIViewController {
        return self.onboardControllers[index]
      }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = onboardControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0  else { return nil }
        guard onboardControllers.count > previousIndex else { return nil }
        return onboardControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = onboardControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < onboardControllers.count else { return nil }
        guard onboardControllers.count > nextIndex else { return nil }
        return onboardControllers[nextIndex]
    }
    
}
