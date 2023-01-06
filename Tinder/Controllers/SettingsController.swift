//
//  SettingsController.swift
//  Tinder
//
//  Created by Beavean on 26.12.2022.
//

import UIKit
import ProgressHUD

protocol SettingsControllerDelegate: AnyObject {
    func settingsController(_ controller: SettingsController?, wantsToUpdate user: User?)
    func settingsControllerWantsToLogout(_ controller: SettingsController)
}

final class SettingsController: UITableViewController {
    
    // MARK: - UI Elements
    
    private lazy var headerView = SettingsHeader(user: user)
    private let footerView = SettingsFooter()
    private let imagePicker = UIImagePickerController()
    
    // MARK: - Properties
    
    weak var delegate: SettingsControllerDelegate?
    private var user: User
    private var imageIndex = 0
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleDone() {
        view.endEditing(true)
        ProgressHUD.show("Saving your data", icon: .succeed, delay: 2)
        Service.saveUserData(user: user) { [weak self] error in
            self?.delegate?.settingsController(self, wantsToUpdate: self?.user)
            if let error {
                ProgressHUD.showError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - API
    
    func uploadImage(image: UIImage) {
        ProgressHUD.show("Saving image", icon: .added, delay: 2)
        Service.uploadImage(image: image) { [weak self] imageUrl in
            self?.user.imageURLs.append(imageUrl)
            ProgressHUD.dismiss()
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        headerView.delegate = self
        imagePicker.delegate = self
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .systemGroupedBackground
        tableView.sectionHeaderTopPadding = 0
        tableView.register(SettingsCell.self, forCellReuseIdentifier: K.UI.settingsCellReuseID)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 88)
        footerView.delegate = self
    }
    
    private func setHeaderImage(_ image: UIImage?) {
        headerView.buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
}

// MARK: - UITableViewDataSource

extension SettingsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        SettingsSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.UI.settingsCellReuseID, for: indexPath) as? SettingsCell,
              let section = SettingsSection(rawValue: indexPath.section)
        else { return UITableViewCell() }
        let viewModel = SettingsViewModel(user: user, section: section)
        cell.viewModel = viewModel
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        32
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSection(rawValue: section) else { return nil }
        return section.description
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return 0 }
        return section == .ageRange ? 96 : 44
    }
}

// MARK: - SettingsHeaderDelegate

extension SettingsController: SettingsHeaderDelegate {
    
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int) {
        self.imageIndex = index
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        uploadImage(image: selectedImage)
        setHeaderImage(selectedImage)
        dismiss(animated: true)
    }
}

// MARK: - SettingsCellDelegate

extension SettingsController: SettingsCellDelegate {
    
    func settingsCell(_ cell: SettingsCell, wantsToUpdateAgeRangeWith sender: UISlider) {
        if sender == cell.minAgeSlider {
            user.minSeekingAge = Int(sender.value)
        } else {
            user.maxSeekingAge = Int(sender.value)
        }
    }
    
    func settingsCell(_ cell: SettingsCell, wantsToUpdateUserWith value: String, for section: SettingsSection) {
        switch section {
        case .name:
            user.name = value
        case .profession:
            user.profession = value
        case .age:
            user.age = Int(value) ?? user.age
        case .bio:
            user.bio = value
        case .ageRange:
            break
        }
    }
}

// MARK: - SettingsFooterDelegate

extension SettingsController: SettingsFooterDelegate {
    
    func handleLogout() {
        delegate?.settingsControllerWantsToLogout(self)
    }
}
