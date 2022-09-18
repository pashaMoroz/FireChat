//
//  LoginController.swift
//  FireChat
//
//  Created by Admin on 15/09/2022.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

protocol AuthenticationControllerProtocol {
    func chackFormStatus()
}

class LoginController: UIViewController {
    
    // MARK:  Properties
    
    private var viewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(containerImage: UIImage(systemName: "envelope"),
                                  textFeild: emailTextFeild, sameDimensionsOfImage: false)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(containerImage: UIImage(systemName: "lock"),
                                  textFeild: passwordTextFeild, sameDimensionsOfImage: true)
    }()
    
    private let loginButton: CustomButton = {
        let button = CustomButton(title: "Log In")
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let emailTextFeild = CustomTextField(placeholder: "Email")
    
    private let passwordTextFeild: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedtitle(firstPart: "Don't have an account?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK:  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK:  Selectors
    
    @objc func handleLogin() {
        guard let email = emailTextFeild.text else { return }
        guard let password = passwordTextFeild.text else { return }
        
        showLoader(true, withText: "Loggin in")
        
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                print("DEBUG: Failed to log user in \(error.localizedDescription)")
                
                    self.showLoader(false)
                return
            }
            self.showLoader(false)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextFeild {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        chackFormStatus()
    }
    
    // MARK:  Helpers
    
    func configureUI() {
        
        configureGradientLayer()
        chackFormStatus()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .systemPurple
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right:  view.rightAnchor, paddingTop:  32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor, paddingLeft: 32,
                                     paddingRight: 32)
        
        emailTextFeild.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextFeild.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK:  AuthenticationControllerProtocol
extension LoginController: AuthenticationControllerProtocol {
    
    func chackFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
        loginButton.backgroundColor = viewModel.buttonTitleColor
    }
}
