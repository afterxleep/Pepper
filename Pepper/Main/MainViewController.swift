//
//  MainViewController.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import UIKit
import QuartzCore
import Lottie

protocol MainViewControllerDelegate: class {
    func mainViewControllerDidTapExceptionBtn()
    func mainViewControllerViewDidAppear()
    func mainViewControllerViewDidDissapear()
}

class MainViewController: UIViewController, MainView, Storyboardeable {
    
    // MARK: Properties
    let updateError = ErrorAlert(title: "Ooops!",
                                               text: "There was a problem updating the tracker blocker.  Please try again later",
                                               button: "OK")
    
    let contentBlockerDisabledError = ErrorAlert(title: "You are not protected!",
                                    text: "It seems Pepper Content Blocker has been disabled.  Please verify your Safari Content Blocker Settings",
                                    button: "OK")
    
    let updateButtonTitleUpdating = "Updating... Please wait"
    let updateButtonTitleDefault = "Update BlackList"
    
    var lockAnimation: AnimationView?
    
    weak var delegate: MainViewControllerDelegate?
    var presenter: MainPresenter?
    
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var exceptionBtn: UIButton!
    @IBOutlet weak var trackerCountLbl: UILabel!
    @IBOutlet weak var trackersLbl: UILabel!
    @IBOutlet weak var animationViewImg: UIImageView!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(view: self)
        validateContentBlockerStatus()
        updateBlockerLists()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.mainViewControllerViewDidAppear()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.mainViewControllerViewDidDissapear()
    }
    
    func toggleButtons() {
        self.updateBtn.isEnabled = !updateBtn.isEnabled ? true : false
        self.exceptionBtn.isEnabled = !exceptionBtn.isEnabled ? true : false
    }
    
    func updateTrackersCount() {
        trackerCountLbl.text = presenter?.totalTrackers()
    }
    
    func notifyUpdateCompleted() {
        toggleButtons()
        self.updateBtn.setTitle(updateButtonTitleDefault, for: .normal)
        updateTrackersCount()
        lockAnimation?.stop()
    }
    
    func notifyUpdateError(error: MainViewError) {
        self.toggleButtons()
        self.updateBtn.setTitle(updateButtonTitleDefault, for: .normal)
        self.lockAnimation?.stop()
        switch error {
        case .errorUpdatingRules:
            presentAlertWithMessage(message: updateError)
        case .genericError:
            presentAlertWithMessage(message: updateError)
        }
    }
    
    func validateContentBlockerStatus() {
        if !(presenter?.contentBlockerStatus() ?? true) {
            DispatchQueue.main.async {
                self.presentAlertWithMessage(message: self.contentBlockerDisabledError)
            }
        }
        updateTrackersCount()
    }
    
    func updateBlockerLists() {
        DispatchQueue.main.async {
            self.updateBtn.setTitle(self.updateButtonTitleUpdating, for: .normal)
            self.toggleButtons()
            self.lockAnimation?.loopMode = .autoReverse
            self.lockAnimation?.play()
        }
        DispatchQueue.global().async {
            self.presenter?.updateBlockLists(updateComplete: { (result) in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.updateTrackersCount()
                        self.notifyUpdateCompleted()
                        return
                    }
                case .failure(let e):
                    DispatchQueue.main.async {
                        self.notifyUpdateError(error: e)
                        return
                    }
                }
            })
        }
    }
    
    func configureUI() {
        navigationController?.navigationBar.isTranslucent = true
        
        // Animation
        let animationView = AnimationView(name: "lock-unlocking")
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        //animationView.center = view.center
        animationView.center = CGPoint(x: view.center.x, y: trackersLbl.center.y - 65)
            animationView.contentMode = .scaleAspectFill
            lockAnimation = animationView
            view.addSubview(animationView)
        }
}

// MARK: IBActions
extension MainViewController {
    @IBAction func didTapUpdateBtn(_ sender: Any) {
        updateBlockerLists()
    }
    @IBAction func didTapExceptionBtn(_ sender: Any) {
        delegate?.mainViewControllerDidTapExceptionBtn()
    }
}
