//
//  Service.swift
//  Tinder
//
//  Created by Beavean on 23.12.2022.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import ProgressHUD

struct Service {
    
    // MARK: - Fetch
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        K.FBUsersCollection.document(uid).getDocument { snapshot, error in
            if let error {
                ProgressHUD.showError(error.localizedDescription)
            }
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(forCurrentUser user: User, completion: @escaping([User]) -> Void) {
        var users = [User]()
        let query = K.FBUsersCollection
            .whereField("age", isGreaterThanOrEqualTo: user.minSeekingAge)
            .whereField("age", isLessThanOrEqualTo: user.maxSeekingAge)
        fetchSwipes { swipedUserIDs in
            query.getDocuments { snapshot, error in
                guard let snapshot else { return }
                if let error {
                    ProgressHUD.showError(error.localizedDescription)
                }
                snapshot.documents.forEach({ document in
                    let dictionary = document.data()
                    let user = User(dictionary: dictionary)
                    guard user.uid != Auth.auth().currentUser?.uid,
                          swipedUserIDs[user.uid] == nil
                    else { return }
                    users.append(user)
                })
                completion(users)
            }
        }
    }
    
    private static func fetchSwipes(completion: @escaping([String: Bool]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FBSwipesCollection.document(uid).getDocument { snapshot, error in
            if let error {
                ProgressHUD.showError(error.localizedDescription)
            }
            guard let data = snapshot?.data() as? [String: Bool] else {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
    
    static func fetchMatches(completion: @escaping([Match]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        K.FBMatchedMessagesCollection.document(uid).collection("matches").getDocuments { snapshot, error in
            if let error {
                ProgressHUD.showError(error.localizedDescription)
            }
            guard let snapshot else { return }
            let matches = snapshot.documents.map({ Match(dictionary: $0.data()) })
            completion(matches)
            
        }
    }
    
    // MARK: - Upload
    
    static func saveUserData(user: User, completion: @escaping(Error?) -> Void) {
        let data = ["uid": user.uid,
                    "fullName": user.fullName,
                    "imageURLs": user.imageURLs,
                    "age": user.age,
                    "bio": user.bio,
                    "profession": user.profession,
                    "minSeekingAge": user.minSeekingAge,
                    "maxSeekingAge": user.maxSeekingAge] as [String: Any]
        K.FBUsersCollection.document(user.uid).setData(data, completion: completion)
    }
    
    static func saveSwipe(forUser user: User, isLike: Bool, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        K.FBSwipesCollection.document(currentUid).getDocument { snapshot, error in
            if let error {
                ProgressHUD.showError(error.localizedDescription)
            }
            let data = [user.uid: isLike]
            if snapshot?.exists == true {
                K.FBSwipesCollection.document(currentUid).updateData(data, completion: completion)
            } else {
                K.FBSwipesCollection.document(currentUid).setData(data, completion: completion)
            }
        }
    }
    
    static func uploadMatch(currentUser: User, matchedUser: User) {
        guard let profileImageUrl = matchedUser.imageURLs.first,
              let currentUserProfileImageUrl = currentUser.imageURLs.first
        else { return }
        
        let matchedUserData = ["uid": matchedUser.uid,
                               "name": matchedUser.fullName,
                               "profileImageUrl": profileImageUrl]
        K.FBMatchedMessagesCollection
            .document(currentUser.uid)
            .collection("matches")
            .document(matchedUser.uid)
            .setData(matchedUserData)
        
        let currentUserData = ["uid": currentUser.uid,
                               "name": currentUser.fullName,
                               "profileImageUrl": currentUserProfileImageUrl]
        K.FBMatchedMessagesCollection
            .document(matchedUser.uid)
            .collection("matches")
            .document(currentUser.uid)
            .setData(currentUserData)
        
    }
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(filename)")
        reference.putData(imageData) { _, error in
            if let error {
                ProgressHUD.showError(error.localizedDescription)
                return
            }
            reference.downloadURL { url, error in
                if let error {
                    ProgressHUD.showError(error.localizedDescription)
                    return
                }
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
    
    // MARK: - Helpers
    
    static func checkIfMatchExists(forUser user: User, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        K.FBSwipesCollection.document(user.uid).getDocument { snapshot, error in
            if let error {
                ProgressHUD.showError(error.localizedDescription)
            }
            guard let data = snapshot?.data(), let didMatch = data[currentUid] as? Bool else { return }
            completion(didMatch)
        }
    }
}
