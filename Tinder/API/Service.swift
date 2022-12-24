//
//  Service.swift
//  Tinder
//
//  Created by Beavean on 23.12.2022.
//

import Foundation
import FirebaseStorage

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
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        Constants.FBUsersCollection.getDocuments { snapshot, error in
            if let error {
                print("DEBUG: Error fetching users -  \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                users.append(user)
                if users.count == snapshot?.documents.count {
                    print("DEBUG: Document count is \(snapshot?.documents.count)")
                    print("DEBUG: Users array count is \(users.count)")
                    completion(users)
                }
            })
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
