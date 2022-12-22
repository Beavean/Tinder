//
//  RegistrationController.swift
//  Tinder
//
//  Created by Beavean on 21.12.2022.
//

import UIKit

final class RegistrationController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold)
        button.setImage(UIImage(systemName: "person.crop.circle.badge.plus", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullNameTextField = CustomTextField(placeholder: "Full Name")
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureField: true)
    
    private lazy var authButton: AuthButton = {
        let button = AuthButton(title: "Sign Up", type: .system)
        button.addTarget(self, action: #selector(handleRegisterUser), for: .touchUpInside)
        return button
    }()
    
    private lazy var goToLoginButton: AuthenticationSwitchButton = {
        let button = AuthenticationSwitchButton(firstTitlePart: "Already have an account?", secondTitlePart: "Sign In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc private func handleRegisterUser() {
        
    }
    
    @objc private func handleSelectPhoto() {
        
    }
    
    @objc private func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        configureGradientLayer()
        view.addSubview(selectPhotoButton)
        selectPhotoButton.setDimensions(height: 250, width: 250)
        selectPhotoButton.centerX(inView: view)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        let stack = UIStackView(arrangedSubviews: [emailTextField, fullNameTextField, passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.anchor(top: selectPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    }
}
