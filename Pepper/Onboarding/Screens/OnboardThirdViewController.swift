//
//  OnboardThirdViewController.swift
//  Pepper
//
//  Created by Daniel Bernal on 23/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import UIKit

class OnboardThirdViewController: UIViewController, Storyboardeable {

    var presenter: OnboardPresenter?
    weak var delegate: OnboardViewControllerDelegate?
    
    @IBAction func didTapNextBtn(_ sender: Any) {
        delegate?.onboardDidTapNextButton(index: 3)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
