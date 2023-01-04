//
//  MessagesController.swift
//  Tinder
//
//  Created by Beavean on 05.01.2023.
//

import UIKit

class MessagesController: UITableViewController {
    
    // MARK: - Properties
    
    private let user: User
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
    }
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleDismissal() {
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    
    private func configureTableView() {
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.UserInterface.messagesCellReuseID)
    }
    
    private func configureNavigationBar() {
        
        let leftButton = UIImageView()
        leftButton.setDimensions(height: 28, width: 28)
        leftButton.isUserInteractionEnabled = true
        leftButton.contentMode = .scaleAspectFit
        leftButton.image = UIImage(systemName: "flame.fill")
        leftButton.tintColor = .orange
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        leftButton.addGestureRecognizer(tap)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        let icon = UIImageView(image: UIImage(systemName: "ellipsis.bubble.fill"))
        icon.tintColor = .systemRed
        navigationItem.titleView = icon
    }
}

// MARK: - UITableViewDataSource

extension MessagesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UserInterface.messagesCellReuseID, for: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MessagesController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.textColor = .systemOrange
        label.text = "Messages"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 12)
        return view
    }
}
