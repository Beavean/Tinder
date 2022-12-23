//
//  Service.swift
//  Tinder
//
//  Created by Beavean on 23.12.2022.
//

import Foundation
import FirebaseStorage

struct Service {
    
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
