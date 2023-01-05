//
//  MatchCellViewModel.swift
//  Tinder
//
//  Created by Beavean on 06.01.2023.
//

import Foundation

struct MatchCellViewModel {
    
    let nameText: String
    var profileImageUrl: URL?
    let uid: String
    
    init(match: Match) {
        nameText = match.name
        profileImageUrl = URL(string: match.profileImageUrl)
        uid =  match.uid
    }
}
