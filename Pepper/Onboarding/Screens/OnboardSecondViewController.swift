//
//  OnboardSecondViewController.swift
//  Pepper
//
//  Created by Daniel Bernal on 23/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import UIKit

class OnboardSecondViewController: UIViewController, Storyboardeable {

    var presenter: OnboardPresenter?
    weak var delegate: OnboardViewControllerDelegate?
    
    let contentBlockerDisabledError = ErrorAlert(title: "Content blocker is not enabled!",
                                    text: "It seems you have not enabled the content blocker yet.  Please verify your Safari Content Blocker Settings to continue",
                                    button: "OK")
    
    @IBAction func didTapNextBtn(_ sender: Any) {
        presenter?.refreshContentBlockerStatus()
        continueOnboarding()
    }
    
    func continueOnboarding() {
        guard let status = presenter?.contentBlockerStatus() else { return }
        if status {
            delegate?.onboardDidTapNextButton(index: 2)
        } else {
            presentAlertWithMessage(message: contentBlockerDisabledError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
