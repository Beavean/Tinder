//
//  SettingsHeader.swift
//  Tinder
//
//  Created by Beavean on 26.12.2022.
//

import UIKit

protocol SettingsHeaderDelegate: AnyObject {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int)
}

final class SettingsHeader: UIView {
    
    // MARK: - UI Elements
    
    private lazy var firstButton = createButton(withIndex: 0)
    private lazy var secondButton = createButton(withIndex: 1)
    private lazy var thirdButton = createButton(withIndex: 2)
    
    // MARK: - Properties

    weak var delegate: SettingsHeaderDelegate?
    var buttons = [UIButton]()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGroupedBackground
        buttons.append(firstButton)
        buttons.append(secondButton)
        buttons.append(thirdButton)
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
    
    @objc private func handleSelectPhoto(sender: UIButton) {
        delegate?.settingsHeader(self, didSelect: sender.tag)
    }
    
    // MARK: - Helpers
    
    private func createButton(withIndex index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = index
        return button
    }
}
