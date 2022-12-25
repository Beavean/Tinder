//
//  HomeController.swift
//  Tinder
//
//  Created by Beavean on 17.12.2022.
//

import UIKit
import FirebaseAuth

final class HomeController: UIViewController {
    
    // MARK: - UI Elements
    
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 10
        return view
    }()
    
    // MARK: - Properties
    
    private var viewModels = [CardViewModel]() {
        didSet { configureCards() }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkIfUserIsLoggedIn()
        fetchUsers()
    }
    
    // MARK: - API
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            print("DEBUG: user is \(user.name)")
        }
    }
    
    private func fetchUsers() {
        Service.fetchUsers { users in
            self.viewModels = users.map({ CardViewModel(user: $0) })
        }
    }
    
    private func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentLoginController()
        } else {
            print("DEBUG: User is logged in")
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    // MARK: - Helpers
    
    private func configureCards() {
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        topStack.delegate = self
        let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
        stack.axis = .vertical
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
    }
    
    private func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let navigation = UINavigationController(rootViewController: controller)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true)
        }
    }
}

// MARK: - HomeNavigationStackViewDelegate

extension HomeController: HomeNavigationStackViewDelegate {
    
    func showSettings() {
        let controller = SettingsController()
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
    
    func showMessages() {
        
    }
}
