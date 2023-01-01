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
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var authButton: AuthButton = {
        let button = AuthButton(title: "Sign Up", type: .system)
        button.addTarget(self, action: #selector(handleRegisterUser), for: .touchUpInside)
        button.alpha = 0.5
        return button
    }()
    
    private lazy var goToLoginButton: AuthenticationSwitchButton = {
        let button = AuthenticationSwitchButton(firstTitlePart: "Already have an account?", secondTitlePart: "Sign In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullNameTextField = CustomTextField(placeholder: "Full Name")
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureField: true)
    
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTextFieldObservers()
    }
    
    // MARK: - Actions
    
    @objc private func textDidChange(sender: UITextField) {
        switch sender {
        case emailTextField:
            viewModel.email = sender.text
        case fullNameTextField:
            viewModel.fullName = sender.text
        case passwordTextField:
            viewModel.password = sender.text
        default:
            break
        }
        checkFormStatus()
    }
    
    @objc private func handleRegisterUser() {
        guard let email = emailTextField.text,
              let fullName = fullNameTextField.text,
              let password = passwordTextField.text,
              let profileImage
        else { return }
        let credentials = AuthCredentials(email: email, password: password, fullName: fullName, profileImage: profileImage)
        AuthService.registerUser(withCredentials: credentials) { error in
            if let error {
                print("DEBUG: Error signing user up", error.localizedDescription)
                return
            }
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc private func handleSelectPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func checkFormStatus() {
        authButton.isEnabled = viewModel.formIsValid
        authButton.alpha = viewModel.formIsValid ? 1 : 0.5
    }
    
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
    
    private func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        selectPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        selectPhotoButton.layer.borderWidth = 3
        selectPhotoButton.layer.cornerRadius = 10
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true)
    }
}
