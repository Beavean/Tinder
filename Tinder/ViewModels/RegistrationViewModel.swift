//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by Beavean on 23.12.2022.
//

import Foundation

struct RegistrationViewModel: AuthenticationViewModel {
    
    var email, fullName, password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullName?.isEmpty == false
    }
}
