//
//  SettingsController.swift
//  Tinder
//
//  Created by Beavean on 26.12.2022.
//

import UIKit

final class SettingsController: UITableViewController {
    
    // MARK: - UI Elements
    
    private let headerView = SettingsHeader()
    private let imagePicker = UIImagePickerController()
    
    // MARK: - Properties
    
    private let user: User
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
        print("DEBUG: Handle did tap done")
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
        tableView.register(SettingsCell.self, forCellReuseIdentifier: Constants.UserInterface.settingsCellReuseID)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UserInterface.settingsCellReuseID, for: indexPath) as? SettingsCell,
              let section = SettingsSection(rawValue: indexPath.section)
        else { return UITableViewCell() }
        let viewModel = SettingsViewModel(user: user, section: section)
        cell.viewModel = viewModel
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
        let selectedImage = info[.originalImage] as? UIImage
        setHeaderImage(selectedImage)
        dismiss(animated: true)
    }
}
