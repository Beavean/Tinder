//
//  Constants.swift
//  Tinder
//
//  Created by Beavean on 24.12.2022.
//

import FirebaseFirestore

struct Constants {
    
    static let FBUsersCollection = Firestore.firestore().collection("users")
    
    struct UserInterface {
        
        static let settingsCellReuseID = "SettingsCell"
        static let barDeselectedColor = UIColor(white: 0, alpha: 0.1)

    }
}
