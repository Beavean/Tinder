//
//  Constants.swift
//  Tinder
//
//  Created by Beavean on 24.12.2022.
//

import FirebaseFirestore

struct Constants {
    
    static let FBUsersCollection = Firestore.firestore().collection("users")
    static let FBSwipesCollection = Firestore.firestore().collection("swipes")

    struct UserInterface {
        
        static let profileCellReuseID = "ProfileCell"
        static let settingsCellReuseID = "SettingsCell"
        static let messagesCellReuseID = "MessagesCell"
        static let matchMessagesCellReuseID = "MatchCell"

        static let barDeselectedColor = UIColor(white: 0, alpha: 0.1)

    }
}
