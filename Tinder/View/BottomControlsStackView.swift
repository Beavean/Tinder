//
//  BottomControlsStackView.swift
//  Tinder
//
//  Created by Beavean on 19.12.2022.
//

import UIKit

class BottomControlsStackView: UIStackView {
    
    // MARK: - Properties
    
    let refreshButton = UIButton(type: .custom)
    let dislikeButton = UIButton(type: .custom)
    let superLikeButton = UIButton(type: .custom)
    let likeButton = UIButton(type: .custom)
    let boostButton = UIButton(type: .custom)
        
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
        [refreshButton, dislikeButton, superLikeButton, likeButton, boostButton].forEach { view in
            addArrangedSubview(view)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
