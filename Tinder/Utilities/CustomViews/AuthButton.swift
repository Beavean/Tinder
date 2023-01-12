//
//  AuthButton.swift
//  Tinder
//
//  Created by Beavean on 21.12.2022.
//

import UIKit

final class AuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.white, for: .normal)
        backgroundColor = .orange
        layer.cornerRadius = 5
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
