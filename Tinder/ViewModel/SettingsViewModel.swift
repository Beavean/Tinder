//
//  SettingsViewModel.swift
//  Tinder
//
//  Created by Beavean on 26.12.2022.
//

import Foundation

enum SettingsSections: Int, CaseIterable {
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
    
    
}
