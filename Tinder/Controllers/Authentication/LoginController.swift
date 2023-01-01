//
//  LoginController.swift
//  Tinder
//
//  Created by Beavean on 21.12.2022.
//

import UIKit

protocol AuthenticationDelegate: AnyObject {
    func authenticationComplete()
}

final class LoginController: UIViewController {
    
    // MARK: - UI Elements
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold)
        imageView.image = UIImage(systemName: "flame.fill", withConfiguration: config)
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var authButton: AuthButton = {
        let button = AuthButton(title: "Sign In", type: .system)
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var goToRegistrationButton: AuthenticationSwitchButton = {
        let button = AuthenticationSwitchButton(firstTitlePart: "Don't have an account?", secondTitlePart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowRegistration), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureField: true)
    
    // MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTextFieldObservers()
    }
    
    // MARK: - Actions
    
    @objc private func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        checkFormStatus()
    }
    
    @objc private func handleLogin() {
        guard let email = emailTextField.text,
        let password = passwordTextField.text else { return }
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            if let error {
                print("DEBUG: Error signing user in \(error.localizedDescription)")
                return
            }
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc private func handleShowRegistration() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    
    private func checkFormStatus() {
        authButton.isEnabled = viewModel.formIsValid
        authButton.alpha = viewModel.formIsValid ? 1 : 0.5
    }
    
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureGradientLayer()
        view.backgroundColor = .systemOrange
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        stack.anchor(top: iconImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        view.addSubview(goToRegistrationButton)
        goToRegistrationButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    }
    
    private func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}
