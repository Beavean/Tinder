//
//  UIViewController+Gradient.swift
//  Tinder
//
//  Created by Beavean on 22.12.2022.
//

import UIKit

extension UIViewController {
    
    func configureGradientLayer() {
        let topColor = UIColor.orange
        let bottomColor = UIColor.red
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.frame
    }
}
