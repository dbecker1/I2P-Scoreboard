//
//  UIView+IBDesignables.swift
//  PortaBoard
//
//  Created by Cliff Panos on 12/4/17.
//  Copyright © 2017 Daniel Becker. All rights reserved.
//

import UIKit

@IBDesignable
class IBView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.clipAndMask()
        }
    }
    
}

@IBDesignable
class IBButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.clipAndMask()
        }
    }
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
            self.clipAndMask()
        }
    }
    
}


/*
 * Extension for UIView to clip an IBDesignable within its proper drawing bounds
 */
extension UIView {
    
    fileprivate func clipAndMask() {
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }

}
