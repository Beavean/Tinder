//
//  SettingsFooter.swift
//  Tinder
//
//  Created by Beavean on 28.12.2022.
//

import UIKit

protocol SettingsFooterDelegate: AnyObject {
    func handleLogout()
}

class SettingsFooter: UIView {
    
    // MARK: - Properties
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: SettingsFooterDelegate?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let spacer = UIView()
        spacer.backgroundColor = .systemGroupedBackground
        addSubview(spacer)
        spacer.setDimensions(height: 32, width: frame.width)
        addSubview(logoutButton)
        logoutButton.anchor(top: spacer.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleLogout() {
        delegate?.handleLogout()
    }
}
