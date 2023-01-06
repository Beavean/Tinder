//
//  ChatController.swift
//  Tinder
//
//  Created by Beavean on 07.01.2023.
//

import UIKit

class ChatController: UICollectionViewController {
    
    // MARK: - UI Elements
    
    private lazy var customInputView: CustomInputView = {
        let inputView = CustomInputView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        inputView.delegate = self
        return inputView
    }()
    
    // MARK: - Properties
    
    private let user: User
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
        set { self.inputAccessoryView = newValue }
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.fullName, prefersLargeTitles: false)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
    }
    
    func configureNavigationBar(withTitle title: String, prefersLargeTitles: Bool = true) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemOrange
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
}

// MARK: - CustomInputViewDelegate

extension ChatController: CustomInputViewDelegate {
    func inputView(_ inputView: CustomInputView, wantsToSend message: String) {
        
    }
}
