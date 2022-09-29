//
//  ProfileFooter.swift
//  FireChat
//
//  Created by Admin on 29/09/2022.
//

import UIKit

protocol ProfileFooterDelegate: AnyObject {
    func hanleLogout()
}

class ProfileFooter: UIView {
    
    // MARK:  Properties
    
    weak var delegate: ProfileFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(hanleLogout), for: .touchUpInside)
        return button
    }()
    
    // MARK:  Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 32, paddingRight: 32)
        logoutButton.setHeight(50)
        logoutButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  Action
    
    @objc func hanleLogout() {
        delegate?.hanleLogout()
    }
}
