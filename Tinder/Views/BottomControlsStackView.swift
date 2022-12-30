//
//  BottomControlsStackView.swift
//  Tinder
//
//  Created by Beavean on 19.12.2022.
//

import UIKit

protocol BottomControlsStackViewDelegate: AnyObject {
    func handleLike()
    func handleDislike()
    func handleRefresh()
}

final class BottomControlsStackView: UIStackView {
    
    // MARK: - UI Elements
    
    private let refreshButton = UIButton(type: .custom)
    private let dislikeButton = UIButton(type: .custom)
    private let superLikeButton = UIButton(type: .custom)
    private let likeButton = UIButton(type: .custom)
    private let boostButton = UIButton(type: .custom)
    
    // MARK: - Properties
    
    weak var delegate: BottomControlsStackViewDelegate?
        
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        refreshButton.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: config), for: .normal)
        refreshButton.tintColor = .systemYellow
        dislikeButton.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        dislikeButton.tintColor = .systemRed
        superLikeButton.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .normal)
        superLikeButton.tintColor = .systemBlue
        likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: config), for: .normal)
        likeButton.tintColor = .cyan
        boostButton.setImage(UIImage(systemName: "bolt.fill", withConfiguration: config), for: .normal)
        boostButton.tintColor = .systemPurple
        refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        [refreshButton, dislikeButton, superLikeButton, likeButton, boostButton].forEach { view in
            addArrangedSubview(view)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleRefresh() {
        delegate?.handleRefresh()
    }
    
    @objc private func handleDislike() {
        delegate?.handleDislike()

    }
    
    @objc private func handleLike() {
        delegate?.handleLike()
    }
}
