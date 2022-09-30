//
//  InputContainerView.swift
//  FireChat
//
//  Created by Admin on 15/09/2022.
//

import UIKit

class InputContainerView: UIView {
    
    init(containerImage: UIImage?, textFeild: UITextField, sameDimensionsOfImage: Bool) {
        super.init(frame: .zero)
        
        setHeight(height: 50)
        
        let iv = UIImageView()
        iv.image = containerImage
        iv.tintColor = .white
        iv.alpha = 0.87
        
        addSubview(iv)
        iv.centerY(inView: self)
        iv.anchor(left: leftAnchor, paddingLeft: 8)
        
        sameDimensionsOfImage ? iv.setDimensions(height: 28, width: 28) : iv.setDimensions(height: 24, width: 28)
        
        addSubview(textFeild)
        textFeild.centerY(inView: self)
        textFeild.anchor(left: iv.rightAnchor,
                         bottom: bottomAnchor, right:  rightAnchor, paddingLeft: 8,
                         paddingBottom: -4)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        dividerView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, height: 0.75)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
