//
//  ActualGradientButton.swift
//  Cocktails
//
//  Created by MacPro on 30.03.2022.
//

import UIKit

class GradientButton: UIButton {
    
    var backgroundGradient: Bool {
        get {
            if layer.sublayers?[0] == gradientLayer {
                return true
            } else {
                return false
            }
        }
        set(state) {
            switch state {
            case true:
                layer.insertSublayer(gradientLayer, at: 0)
            case false:
                gradientLayer.removeFromSuperlayer()
            }
        }
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [#colorLiteral(red: 1, green: 0.2542519784, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0, blue: 1, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.cornerRadius = 10
        return gradient
    }()
}
