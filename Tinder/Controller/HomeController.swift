//
//  HomeController.swift
//  Tinder
//
//  Created by Beavean on 17.12.2022.
//

import UIKit

final class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()

    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 10
        return view
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCards()
    }
    
    // MARK: - Helpers
    
    private func configureCards() {
        let firstUser = User(name: "Jane", age: 25, images: [UIImage(named: "jane1")!, UIImage(named: "jane2")!, UIImage(named: "jane3")!])
        let secondUser = User(name: "Kelly", age: 26, images: [UIImage(named: "kelly1")!, UIImage(named: "kelly2")!, UIImage(named: "kelly3")!])
        let firstCardView = CardView(viewModel: CardViewModel(user: firstUser))
        let secondCardView = CardView(viewModel: CardViewModel(user: secondUser))
        deckView.addSubview(firstCardView)
        deckView.addSubview(secondCardView)
        firstCardView.fillSuperview()
        secondCardView.fillSuperview()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
        stack.axis = .vertical
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
    }
}
