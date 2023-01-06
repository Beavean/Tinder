//
//  SettingsViewModel.swift
//  Tinder
//
//  Created by Beavean on 26.12.2022.
//

import Foundation

enum SettingsSection: Int, CaseIterable {
    case name
    case profession
    case age
    case bio
    case ageRange
    
    var description: String {
        switch self {
        case .name:
            return "Name"
        case .profession:
            return "Profession"
        case .age:
            return "Age"
        case .bio:
            return "Bio"
        case .ageRange:
            return "Seeking Age Range"
        }
    }
}

struct SettingsViewModel {
    
    // MARK: - Properties
    
    let user: User
    let section: SettingsSection
    let placeholderText: String
    var value: String?
    
    var shouldHideInputField: Bool {
        section == .ageRange
    }
    
    var shouldHideSlider: Bool {
        section != .ageRange
    }
    
    var minAgeSliderValue: Float {
        return Float(user.minSeekingAge)
    }
    
    var maxAgeSliderValue: Float {
        return Float(user.maxSeekingAge)
    }
    
    // MARK: - Lifecycle
    
    init(user: User, section: SettingsSection) {
        self.user = user
        self.section = section
        placeholderText = "Enter \(section.description.lowercased())..."
        switch section {
        case .name:
            value = user.fullName
        case .profession:
            value = user.profession
        case .age:
            value = "\(user.age)"
        case .bio:
            value = user.bio
        case .ageRange:
            break
        }
    }
    
    // MARK: - Helpers
    
    func minAgeLabelText(forValue value: Float) -> String {
        return "Min: \(Int(value))"
    }
    
    func maxAgeLabelText(forValue value: Float) -> String {
        return "Max: \(Int(value))"
    }
}
