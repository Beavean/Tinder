//
//  MatchView.swift
//  Tinder
//
//  Created by Beavean on 02.01.2023.
//

import UIKit

class MatchView: UIView {
    
    // MARK: - Properties
    
    private let currentUser: User
    private let matchedUser: User
    
    // MARK: - Init
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        super.init(frame: .zero)
        backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
