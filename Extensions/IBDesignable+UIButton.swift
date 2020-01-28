//
//  UIComponents.swift
//  Pepper
//
//  Created by Daniel Bernal on 21/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import UIKit

@IBDesignable class DefaultButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        decorate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        decorate()
    }
    
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            setupCornerRadius(radius: cornerRadius)
        }
    }
    
    @IBInspectable var backgroundImageColor: UIColor = UIColor.init(red: 122/255.0, green: 122/255.0, blue: 122/255.0, alpha: 1) {
        didSet {
            setupColor(color: backgroundImageColor)
        }
    }
    
    func setupCornerRadius (radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
    func setupColor(color: UIColor) {
        let image = createImage(color: color)
        setBackgroundImage(image, for: UIControl.State.normal)
        clipsToBounds = true
    }
    
    func createImage(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    func decorate() {
        setupCornerRadius(radius: cornerRadius)
        setupColor(color: backgroundImageColor)
    }
    
    override func prepareForInterfaceBuilder() {
        decorate()
    }
}
