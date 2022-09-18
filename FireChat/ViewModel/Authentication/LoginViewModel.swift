//
//  LoginViewModel.swift
//  FireChat
//
//  Created by Admin on 17/09/2022.
//

import UIKit

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationProtocol  {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .systemPink : UIColor(white: 1, alpha: 0.67)
    }
}
