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
    
    private let user: User
    private let section: SettingsSection
    
    var shouldHideInputField: Bool {
        section == .ageRange
    }
    
    var shouldHideSlider: Bool {
        section != .ageRange
    }
    
    init(user: User, section: SettingsSection) {
        self.user = user
        self.section = section
    }
}
