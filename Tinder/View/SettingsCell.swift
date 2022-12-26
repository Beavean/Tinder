//
//  SettingsCell.swift
//  Tinder
//
//  Created by Beavean on 26.12.2022.
//

import UIKit

protocol SettingsCellDelegate: AnyObject {
    func settingsCell(_ cell: SettingsCell, wantsToUpdateUserWith value: String, for section: SettingsSection)
}

final class SettingsCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    lazy var inputField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        let paddingView = UIView()
        paddingView.setDimensions(height: 50, width: 28)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        return textField
    }()
    
    lazy var minAgeLabel = UILabel()
    lazy var maxAgeLabel = UILabel()
    lazy var minAgeSlider = createAgeRangeSlider()
    lazy var maxAgeSlider = createAgeRangeSlider()
    var sliderStack = UIStackView()

    // MARK: - Properties
    
    weak var delegate: SettingsCellDelegate?
    var viewModel: SettingsViewModel! {
        didSet { configure() }
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        minAgeLabel.text = "Min: 18"
        maxAgeLabel.text = "Max: 60"

        contentView.addSubview(inputField)
        inputField.fillSuperview()
        
        let minStack = UIStackView(arrangedSubviews: [minAgeLabel, minAgeSlider])
        minStack.spacing = 24
        
        let maxStack = UIStackView(arrangedSubviews: [maxAgeLabel, maxAgeSlider])
        minStack.spacing = 24
        
        sliderStack = UIStackView(arrangedSubviews: [minStack, maxStack])
        sliderStack.axis = .vertical
        sliderStack.spacing = 16
        contentView.addSubview(sliderStack)
        sliderStack.centerY(inView: self)
        sliderStack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 24, paddingRight: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handleUpdateUserInfo(sender: UITextField) {
        guard let value = sender.text else { return }
        delegate?.settingsCell(self, wantsToUpdateUserWith: value, for: viewModel.section)
    }
    
    @objc private func handleAgeRangeChanged() {
        
    }
    
    // MARK: - Helpers
    
    private func configure() {
        inputField.isHidden = viewModel.shouldHideInputField
        sliderStack.isHidden = viewModel.shouldHideSlider
        inputField.placeholder = viewModel.placeholderText
        inputField.text = viewModel.value
    }
    
    private func createAgeRangeSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 60
        slider.addTarget(self, action: #selector(handleAgeRangeChanged), for: .valueChanged)
        return slider
    }
}
