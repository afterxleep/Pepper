//
//  OnboardFourthViewController.swift
//  Pepper
//
//  Created by Daniel Bernal on 23/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import UIKit

class OnboardFourthViewController: UIViewController, Storyboardeable {

    var presenter: OnboardPresenter?
    weak var delegate: OnboardViewControllerDelegate?
    
    @IBAction func didTapFinalButton(_ sender: Any) {
        delegate?.onBoardDidTapFinalButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
