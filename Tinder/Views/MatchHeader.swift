//
//  MatchHeader.swift
//  Tinder
//
//  Created by Beavean on 05.01.2023.
//

import UIKit

protocol MatchHeaderDelegate: AnyObject {
    func matchHeader(_ header: MatchHeader, wantsToStartChatWith uid: String)
}

final class MatchHeader: UICollectionReusableView {
    
    // MARK: - UI Elements
    
    private let newMatchesLabel: UILabel = {
        let label = UILabel()
        label.text = "New Matches"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .systemRed
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: K.UI.matchMessagesCellReuseID)
        return collectionView
    }()
    
    // MARK: - Properties
    
    weak var delegate: MatchHeaderDelegate?
    var matches = [Match]() {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(newMatchesLabel)
        newMatchesLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        addSubview(collectionView)
        collectionView.anchor(top: newMatchesLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 24, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource

extension MatchHeader: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.UI.matchMessagesCellReuseID, for: indexPath) as? MatchCell else { return UICollectionViewCell() }
        cell.viewModel = MatchCellViewModel(match: matches[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MatchHeader: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = matches[indexPath.row].uid
        delegate?.matchHeader(self, wantsToStartChatWith: uid)
    }
}

// MARK: - UICollectionViewDelegate

extension MatchHeader: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 140)
    }
}
