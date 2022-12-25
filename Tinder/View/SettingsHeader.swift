//
//  SettingsHeader.swift
//  Tinder
//
//  Created by Beavean on 26.12.2022.
//

import UIKit

class SettingsHeader: UIView {
    
    // MARK: - UI Elements
    
    var buttons = [UIButton]()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGroupedBackground
        let firstButton = createButton()
        let secondButton = createButton()
        let thirdButton = createButton()
        addSubview(firstButton)
        firstButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16)
        firstButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        let stack = UIStackView(arrangedSubviews: [secondButton, thirdButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        addSubview(stack)
        stack.anchor(top: topAnchor, left: firstButton.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleSelectPhoto() {
        print("DEBUG: Show photo selector here")
    }
    
    // MARK: - Helpers
    
    private func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
}
