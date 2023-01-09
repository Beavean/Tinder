//
//  ProfileController.swift
//  Tinder
//
//  Created by Beavean on 29.12.2022.
//

import UIKit

protocol ProfileControllerDelegate: AnyObject {
    func profileController(_ controller: ProfileController, didLikeUser user: User)
    func profileController(_ controller: ProfileController, didDislikeUser user: User)
}

final class ProfileController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + 100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: K.UI.profileCellReuseID)
        return collectionView
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
        button.setImage(UIImage(systemName: "arrow.down.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .systemOrange
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Full Name - Age"
        return label
    }()
    
    private let professionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Profession"
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Bio & info"
        return label
    }()
    
    private lazy var barStackView = SegmentedBarView(numberOfSegments: viewModel.imageURLs.count)
    private let dislikeButton = UIButton(type: .custom)
    private let superLikeButton = UIButton(type: .custom)
    private let likeButton = UIButton(type: .custom)
    
    // MARK: - Properties
    
    weak var delegate: ProfileControllerDelegate?
    private let user: User
    private lazy var viewModel = ProfileViewModel(user: user)
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadUserData()
    }
    
    // MARK: - Actions
    
    @objc private func handleDislike() {
        delegate?.profileController(self, didDislikeUser: user)
    }
    
    @objc private func handleSuperLike() {
        
    }
    
    @objc private func handleLike() {
        delegate?.profileController(self, didLikeUser: user)
    }
    
    @objc private func handleDismissal() {
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    
    private func loadUserData() {
        infoLabel.attributedText = viewModel.userDetailsAttributedString
        professionLabel.text = viewModel.profession
        bioLabel.text = viewModel.bio
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(dismissButton)
        dismissButton.setDimensions(height: 40, width: 40)
        dismissButton.anchor(top: collectionView.bottomAnchor, right: view.rightAnchor, paddingTop: -20, paddingRight: 16)
        let infoStack = UIStackView(arrangedSubviews: [infoLabel, professionLabel, bioLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        view.addSubview(infoStack)
        infoStack.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor)
        
        configureBottomControls()
        configureBarStackView()
    }
    
    private func configureBarStackView() {
        view.addSubview(barStackView)
        barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 4)
    }
    
    private func configureBottomControls() {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        dislikeButton.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        dislikeButton.tintColor = .systemRed
        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        superLikeButton.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .normal)
        superLikeButton.tintColor = .systemBlue
        superLikeButton.addTarget(self, action: #selector(handleSuperLike), for: .touchUpInside)
        likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: config), for: .normal)
        likeButton.tintColor = .cyan
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        let stack = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.spacing = 24
        stack.setDimensions(height: 80, width: 300)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.UI.profileCellReuseID, for: indexPath) as? ProfileCell else { return UICollectionViewCell() }
        cell.imageView.sd_setImage(with: viewModel.imageURLs[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        barStackView.setHighlighted(index: indexPath.row)
    }
}

// MARK: - UICollectionViewFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
