//
//  CardViewModel.swift
//  Tinder
//
//  Created by Beavean on 21.12.2022.
//

import UIKit

final class CardViewModel {
    
    let user: User
    let imageURLs: [String]
    let userInfoText: NSAttributedString
    var imageURL: URL?
    private var imageIndex = 0
    var index: Int {
        return imageIndex
    }
    
    init(user: User) {
        self.user = user
        let attributedText = NSMutableAttributedString(string: user.fullName, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: " \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
        self.userInfoText = attributedText
        self.imageURLs = user.imageURLs
        self.imageURL = URL(string: user.imageURLs[0])
    }
    
    func showNextPhoto() {
        guard imageIndex < imageURLs.count - 1 else { return }
        imageIndex += 1
        imageURL = URL(string: imageURLs[imageIndex])
    }
    
    func showPreviousPhoto() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
        imageURL = URL(string: imageURLs[imageIndex])
    }
}
