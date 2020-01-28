//
//  BasePresenter.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import Foundation

protocol BasePresenter {
    
    associatedtype View
    
    func attachView(view: View)
    func detachView()
    func destroy()
    
}
