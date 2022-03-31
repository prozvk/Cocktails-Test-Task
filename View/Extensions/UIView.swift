//
//  UIView.swift
//  Cocktails
//
//  Created by MacPro on 30.03.2022.
//

import UIKit

extension UIView {
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = #colorLiteral(red: 0.2354060914, green: 0.2354060914, blue: 0.2354060914, alpha: 1)
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 7
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
