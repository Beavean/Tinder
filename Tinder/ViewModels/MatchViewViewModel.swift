//
//  MatchViewViewModel.swift
//  Tinder
//
//  Created by Beavean on 04.01.2023.
//

import Foundation

struct MatchViewViewModel {
    
    private let currentUser: User
    let matchedUser: User
    let matchLabelText: String
    var currentUserImageUrl: URL?
    var matchedUserImageUrl: URL?
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        matchLabelText = "You and \(matchedUser.fullName) have liked each other!"
        guard let currentUserImageUrl = currentUser.imageURLs.first,
        let matchedUserImageUrl = matchedUser.imageURLs.first
        else { return }
        self.currentUserImageUrl = URL(string: currentUserImageUrl)
        self.matchedUserImageUrl = URL(string: matchedUserImageUrl)
    }
}
