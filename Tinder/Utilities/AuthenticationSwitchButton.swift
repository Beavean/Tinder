//
//  AuthenticationSwitchButton.swift
//  Tinder
//
//  Created by Beavean on 22.12.2022.
//

import UIKit

class AuthenticationSwitchButton: UIButton {
    
    init(firstTitlePart: String, secondTitlePart: String) {
        super.init(frame: .zero)
        let attributedTitle = NSMutableAttributedString(string: firstTitlePart, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: " "))
        attributedTitle.append(NSAttributedString(string: secondTitlePart, attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        setAttributedTitle(attributedTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
