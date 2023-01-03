//
//  SendMessageButton.swift
//  Tinder
//
//  Created by Beavean on 03.01.2023.
//

import UIKit

class SendMessageButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = UIColor.systemOrange
        let rightColor = UIColor.systemRed
        
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        
        gradientLayer.frame = rect
    }
}
