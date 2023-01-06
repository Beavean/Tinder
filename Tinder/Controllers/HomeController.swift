//
//  HomeController.swift
//  Tinder
//
//  Created by Beavean on 17.12.2022.
//

import UIKit
import FirebaseAuth
import ProgressHUD

final class HomeController: UIViewController {
    
    // MARK: - UI Elements
    
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    // MARK: - Properties
    
    private var user: User?
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    
    private var viewModels = [CardViewModel]() {
        didSet { configureCards() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkIfUserIsLoggedIn()
        fetchCurrentUserAndCards()
    }
    
    // MARK: - API
    
    private func fetchUsers(forCurrentUser user: User) {
        Service.fetchUsers(forCurrentUser: user) { users in
            self.viewModels = users.map({ CardViewModel(user: $0) })
        }
    }
    
    private func fetchCurrentUserAndCards() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            self.user = user
            self.fetchUsers(forCurrentUser: user)
        }
    }
    
    private func checkIfUserIsLoggedIn() {
        guard Auth.auth().currentUser == nil else { return }
        presentLoginController()
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            ProgressHUD.showError(error.localizedDescription)
        }
    }
    
    private func saveSwipeAndCheckForMatch(forUser user: User, didLike: Bool) {
        Service.saveSwipe(forUser: user, isLike: didLike) { [weak self] _ in
            self?.topCardView = self?.cardViews.last
            guard didLike else { return }
            Service.checkIfMatchExists(forUser: user) { _ in
                self?.presentMatchView(forUser: user)
                guard let currentUser = self?.user else { return }
                Service.uploadMatch(currentUser: currentUser, matchedUser: user)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func configureCards() {
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            cardView.delegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        cardViews = deckView.subviews.map({ ($0 as? CardView)! })
        topCardView = cardViews.last
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        topStack.delegate = self
        bottomStack.delegate = self
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
            controller.delegate = self
            let navigation = UINavigationController(rootViewController: controller)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true)
        }
    }
    
    private func presentMatchView(forUser user: User) {
        guard let currentUser = self.user else { return }
        let viewModel = MatchViewViewModel(currentUser: currentUser, matchedUser: user)
        let matchView = MatchView(viewModel: viewModel)
        matchView.delegate = self
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    private func performSwipeAnimation(shouldLike: Bool) {
        guard let width = self.topCardView?.frame.width,
        let height = self.topCardView?.frame.height
        else { return }
        let translation: CGFloat = shouldLike ? 700 : -700
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.topCardView?.frame = CGRect(x: translation, y: 0, width: width, height: height)
        } completion: { [self] _ in
            topCardView?.removeFromSuperview()
            guard !cardViews.isEmpty else { return }
            cardViews.remove(at: cardViews.count - 1)
            topCardView = cardViews.last
        }
    }
}

// MARK: - HomeNavigationStackViewDelegate

extension HomeController: HomeNavigationStackViewDelegate {
    
    func showSettings() {
        guard let user = self.user else { return }
        let controller = SettingsController(user: user)
        controller.delegate = self
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
    
    func showMessages() {
        guard let user else { return }
        let controller = MessagesController(user: user)
        let navigation = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
}

// MARK: - SettingsControllerDelegate

extension HomeController: SettingsControllerDelegate {
    
    func settingsControllerWantsToLogout(_ controller: SettingsController) {
        controller.dismiss(animated: true)
        logOut()
    }
    
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        self.user = user
    }
}

// MARK: - CardViewDelegate

extension HomeController: CardViewDelegate {
    
    func cardView(_ view: CardView, didLikeUser: Bool) {
        view.removeFromSuperview()
        self.cardViews.removeAll(where: { view == $0 })
        guard let user = topCardView?.viewModel.user else { return }
        saveSwipeAndCheckForMatch(forUser: user, didLike: didLikeUser)
        self.topCardView = cardViews.last
    }
    
    func cardView(_ view: CardView, wantsToShowProfileFor user: User) {
        let controller = ProfileController(user: user)
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
}

// MARK: - BottomControlsStackViewDelegate

extension HomeController: BottomControlsStackViewDelegate {
    
    func handleLike() {
        guard let topCard = topCardView else { return }
        performSwipeAnimation(shouldLike: true)
        saveSwipeAndCheckForMatch(forUser: topCard.viewModel.user, didLike: true)
    }
    
    func handleDislike() {
        guard let topCard = topCardView else { return }
        performSwipeAnimation(shouldLike: false)
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: false, completion: nil)
    }
    
    func handleRefresh() {
        guard let user = self.user else { return }
        Service.fetchUsers(forCurrentUser: user) { users in
            self.viewModels = users.map({ CardViewModel(user: $0) })
        }
    }
}

// MARK: - ProfileControllerDelegate

extension HomeController: ProfileControllerDelegate {
    
    func profileController(_ controller: ProfileController, didLikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: true)
            self.saveSwipeAndCheckForMatch(forUser: user, didLike: true)
        }
    }
    
    func profileController(_ controller: ProfileController, didDislikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: false)
            Service.saveSwipe(forUser: user, isLike: false, completion: nil)
        }
    }
}

// MARK: - AuthenticationDelegate

extension HomeController: AuthenticationDelegate {
    
    func authenticationComplete() {
        dismiss(animated: true)
        fetchCurrentUserAndCards()
    }
}

// MARK: - MatchViewDelegate

extension HomeController: MatchViewDelegate {
    
    func matchView(_ view: MatchView, wantsToSendMessageTo user: User) {
        
    }
}
