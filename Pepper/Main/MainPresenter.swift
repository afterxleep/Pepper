//
//  MainPresenter.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

class MainPresenter: BasePresenter {
    
    typealias View = MainView
    private var mainView: MainView?
    
    let contentBlockerManager: ContentBlockerManager?
    let contentBlockerHelper: SFCBHelper?
    
    init(contentBlockerManager: ContentBlockerManager, contentBlockerHelper: SFCBHelper) {
        self.contentBlockerManager = contentBlockerManager
        self.contentBlockerHelper = contentBlockerHelper
        setupNotifications()
        refreshContentBlockerStatus()
    }
    
    func attachView(view: MainView) {
        mainView = view
    }
        
    func detachView() {
        mainView = nil
    }
        
    func destroy() {            
    }
    
    func updateBlockLists(updateComplete: @escaping (Result<Bool, MainViewError>) -> Void) {
        contentBlockerManager?.performUpdate(completion: { (result) in
            switch result {
            case .success:                    
                updateComplete(.success(true))
            case .failure(let error):
                switch error {
                case .cannotUpdateRules:
                    updateComplete(.failure(.errorUpdatingRules))
                default:
                    updateComplete(.failure(.genericError))
                }
            }
        })        
    }
    
    func refreshContentBlockerStatus() {
        contentBlockerHelper?.getContentBlockerStatus(completion: { (result) in
            if case .success(let status) = result {
                UserDefaults.standard.set(status, forKey: Constants.UserDefaultsKeys.isBlockerExtensionActive.rawValue)
                DispatchQueue.main.async {
                    self.mainView?.validateContentBlockerStatus()
                }
            }
        })
    }
    
    func setupNotifications() {
        // Register for Will Enter Foreground Notifications to validated tracker status
        NotificationCenter.default.addObserver(self, selector: #selector(onWillEnterForeground(_:)),
                                                   name: .willEnterForeground,
                                                   object: nil)
    }
    
    @objc func onWillEnterForeground(_ notification: Notification) {
        refreshContentBlockerStatus()
    }
}

extension MainPresenter: MainDataSource {
    
    func totalTrackers() -> String {
         if UserDefaults.standard.bool(forKey: Constants.UserDefaultsKeys.isBlockerExtensionActive.rawValue) {
             return UserDefaults.standard.integer(forKey: Constants.UserDefaultsKeys.totalTrackersBlocked.rawValue).formatted()
         }
         return "0"
     }
     
     func contentBlockerStatus() -> Bool {
         return UserDefaults.standard.bool(forKey: Constants.UserDefaultsKeys.isBlockerExtensionActive.rawValue)
     }
}
