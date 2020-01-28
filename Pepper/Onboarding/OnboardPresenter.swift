//
//  OnboardPresenter.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

class OnboardPresenter: BasePresenter {
    
    typealias View = OnboardView
    private var onboardView: OnboardView?
    let contentBlockerHelper: SFCBHelper?
    
    init(contentBlockerHelper: SFCBHelper) {
        self.contentBlockerHelper = contentBlockerHelper
    }
    
    func attachView(view: OnboardView) {
        onboardView = view
        setupNotifications()
    }
        
    func detachView() {
        onboardView = nil
    }
        
    func destroy() {            
    }
    
    func setupNotifications() {
        // Register for Will Enter Foreground Notifications to validated tracker status
        NotificationCenter.default.addObserver(self, selector: #selector(onWillEnterForeground(_:)),
                                                   name: .willEnterForeground,
                                                   object: nil)
    }
    
    func refreshContentBlockerStatus() {
        contentBlockerHelper?.getContentBlockerStatus(completion: { (result) in
            if case .success(let status) = result {
                UserDefaults.standard.set(status, forKey: Constants.UserDefaultsKeys.isBlockerExtensionActive.rawValue)
            }
        })
    }
    
    @objc func onWillEnterForeground(_ notification: Notification) {
        refreshContentBlockerStatus()
    }
    
    func contentBlockerStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.UserDefaultsKeys.isBlockerExtensionActive.rawValue)
    }
    
}
