//
//  RegistrationController.swift
//  FireChat
//
//  Created by Admin on 15/09/2022.
//

import UIKit
import FirebaseCore

class RegistrationController: UIViewController {
    
    // MARK:  Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSecectPhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(containerImage: UIImage(systemName: "envelope"),
                                  textFeild: emailTextFeild, sameDimensionsOfImage: false)
    }()
    
    private lazy var fullnameContainerView: UIView = {
        return InputContainerView(containerImage: UIImage(systemName: "person"),
                                  textFeild: fullnameTextFeild, sameDimensionsOfImage: true)
    }()
    
    private lazy var usernameContainerView: UIView = {
        return InputContainerView(containerImage: UIImage(systemName: "person.fill"),
                                  textFeild: usernameTextFeild, sameDimensionsOfImage: true)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(containerImage: UIImage(systemName: "lock"),
                                  textFeild: passwordTextFeild, sameDimensionsOfImage: true)
    }()
    
    private let emailTextFeild = CustomTextField(placeholder: "Email")
    
    private let fullnameTextFeild = CustomTextField(placeholder: "Full Name")
    
    private let usernameTextFeild = CustomTextField(placeholder: "Username")
    
    private let passwordTextFeild: CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let signUpButton: CustomButton = {
        let button = CustomButton(title: "Sign Up")
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedtitle(firstPart: "Already have an account?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK:  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK:  Selectors
    
    @objc func handleRegistration() {
        guard let email = emailTextFeild.text else { return }
        guard let password = passwordTextFeild.text else { return }
        guard let fullname = fullnameTextFeild.text else { return }
        guard let username = usernameTextFeild.text else { return }
        guard let profileImage = profileImage else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname,
                                          username: username, profileImage: profileImage)
        
        showLoader(true, withText: "Signing You Up")
        
        AuthService.registerUser(withCredential: credentials) { error in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                self.showLoader(false)
                return
            }
            self.showLoader(false)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleSecectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        
        if sender == emailTextFeild {
            viewModel.email = sender.text
        } else if sender == passwordTextFeild {
            viewModel.password = sender.text
        } else if sender == fullnameTextFeild {
            viewModel.fullname = sender.text
        } else if sender == usernameTextFeild {
            viewModel.username = sender.text
        }
        
        chackFormStatus()
    }
    
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    // MARK:  Helpers
    
    func configureUI() {
        configureGradientLayer()
        chackFormStatus()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(height: 200, width: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   fullnameContainerView,
                                                   usernameContainerView,
                                                   signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right:  view.rightAnchor, paddingTop:  32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor, paddingLeft: 32,
                                     paddingRight: 32)
        
    }
    
    func configureNotificationObservers() {
        emailTextFeild.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextFeild.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextFeild.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextFeild.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
    [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        profileImage = image
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
}

// MARK:  AuthenticationControllerProtocol

extension RegistrationController: AuthenticationControllerProtocol {
    
    func chackFormStatus() {
        if viewModel.formIsValid {
            signUpButton.isEnabled = true
        } else {
            signUpButton.isEnabled = false
        }
        signUpButton.backgroundColor = viewModel.buttonTitleColor
    }
}
