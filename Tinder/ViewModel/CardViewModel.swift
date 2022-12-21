//
//  CardViewModel.swift
//  Tinder
//
//  Created by Beavean on 21.12.2022.
//

import UIKit

class CardViewModel {
    
    let user: User
    let userInfoText: NSAttributedString
    var imageToShow: UIImage?
    private var imageIndex = 0
    
    init(user: User) {
        self.user = user
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: " \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white]))
        self.userInfoText = attributedText
    }
    
    func showNextPhoto() {
        guard imageIndex < user.images.count - 1 else { return }
        imageIndex += 1
        self.imageToShow = user.images[imageIndex]
    }
    
    func showPreviousPhoto() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
        self.imageToShow = user.images[imageIndex]
    }
}
