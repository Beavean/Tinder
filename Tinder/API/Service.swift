//
//  Service.swift
//  Tinder
//
//  Created by Beavean on 23.12.2022.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

struct Service {
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        Constants.FBUsersCollection.document(uid).getDocument { snapshot, error in
            if let error {
                print("DEBUG: Error fetching users -  \(error.localizedDescription)")
            }
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(forCurrentUser user: User, completion: @escaping([User]) -> Void) {
        var users = [User]()
        let query = Constants.FBSwipesCollection
            .whereField("age", isGreaterThanOrEqualTo: user.minSeekingAge)
            .whereField("age", isLessThanOrEqualTo: user.maxSeekingAge)
        Constants.FBUsersCollection.getDocuments { snapshot, error in
            guard let snapshot else { return }
            if let error {
                print("DEBUG: Error fetching users -  \(error.localizedDescription)")
            }
            snapshot.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                guard user.uid != Auth.auth().currentUser?.uid else { return }
                users.append(user)
                if users.count == snapshot.documents.count - 1 {
                    completion(users)
                }
            })
        }
    }
    
    static func saveUserData(user: User, completion: @escaping(Error?) -> Void) {
        let data = ["uid": user.uid,
                    "fullName": user.name,
                    "imageURLs": user.imageURLs,
                    "age": user.age,
                    "bio": user.bio,
                    "profession": user.profession,
                    "minSeekingAge": user.minSeekingAge,
                    "maxSeekingAge": user.maxSeekingAge] as [String: Any]
        Constants.FBUsersCollection.document(user.uid).setData(data, completion: completion)
    }
    
    static func saveSwipe(forUser user: User, isLike: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let shouldLike = isLike ? 1 : 0
        Constants.FBSwipesCollection.document(uid).getDocument { snapshot, error in
            let data = [user.uid: isLike]
            if snapshot?.exists == true {
                Constants.FBSwipesCollection.document(uid).updateData(data)
            } else {
                Constants.FBSwipesCollection.document(uid).setData(data)
            }
        }
    }
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(filename)")
        reference.putData(imageData) { _, error in
            if let error {
                print("DEBUG: Error uploading image", error.localizedDescription)
                return
            }
            reference.downloadURL { url, error in
                if let error {
                    print("DEBUG: Error downloading image", error.localizedDescription)
                    return
                }
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
