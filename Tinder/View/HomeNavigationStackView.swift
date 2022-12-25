//
//  HomeNavigationStackView.swift
//  Tinder
//
//  Created by Beavean on 19.12.2022.
//

import UIKit

protocol HomeNavigationStackViewDelegate: AnyObject {
    func showSettings()
    func showMessages()
}

final class HomeNavigationStackView: UIStackView {
    
    // MARK: - Properties
    
    weak var delegate: HomeNavigationStackViewDelegate?
    private let settingsButton = UIButton(type: .system)
    private let messageButton = UIButton(type: .system)
    private let tinderIcon = UIImageView(image: UIImage(systemName: "flame.fill"))
        
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        tinderIcon.contentMode = .scaleAspectFit
        tinderIcon.tintColor = .orange
        tinderIcon.setDimensions(height: 40, width: 30)
        settingsButton.setImage(UIImage(systemName: "person.fill"), for: .normal)
        settingsButton.tintColor = .systemGray
        messageButton.setImage(UIImage(systemName: "ellipsis.bubble.fill"), for: .normal)
        messageButton.tintColor = .systemGray
        [settingsButton, UIView(), tinderIcon, UIView(), messageButton].forEach { view in
            addArrangedSubview(view)
        }
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        settingsButton.addTarget(self, action: #selector(handleShowSettings), for: .touchUpInside)
        messageButton.addTarget(self, action: #selector(handleShowMessages), for: .touchUpInside)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleShowSettings() {
        delegate?.showSettings()
    }
    
    @objc private func handleShowMessages() {
        delegate?.showMessages()
    }
}
