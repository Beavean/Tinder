//
//  HomeController.swift
//  Tinder
//
//  Created by Beavean on 17.12.2022.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private let topStack = HomeNavigationStackView()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(topStack)
        topStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
    }
}
