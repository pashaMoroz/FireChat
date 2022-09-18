//
//  RegistrationViewModel.swift
//  FireChat
//
//  Created by Admin on 17/09/2022.
//

import UIKit

struct RegistrationViewModel: AuthenticationProtocol  {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
        && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .systemPink : UIColor(white: 1, alpha: 0.67)
    }
}
