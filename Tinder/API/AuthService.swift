//
//  AuthService.swift
//  Tinder
//
//  Created by Beavean on 23.12.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthService {
    
    static func logUserIn(withEmail email: String,
                          password: String,
                          completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping((Error?) -> Void)) {
        Service.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                if let error {
                    print("DEBUG: Error signing user up.", error.localizedDescription)
                    return
                }
                guard let uid = result?.user.uid else { return }
                let data = ["email": credentials.email,
                            "fullName": credentials.fullName,
                            "imageURLs": [imageUrl],
                            "uid": uid,
                            "age": 99] as [String: Any]
                Constants.FBUsersCollection.document(uid).setData(data, completion: completion)
            }
        }
    }
}
