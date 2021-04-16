//
//  LoginView.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/13/21.
//

import UIKit

class LoginView : UIView {

    private(set) var loginButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.layer.cornerRadius = 16.0
        button.layer.masksToBounds = true
        button.accessibilityIdentifier = "Login"
        return button
    }()

    private(set) var signUpButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.layer.cornerRadius = 16.0
        button.layer.masksToBounds = true
        return button
    }()

    private(set) var loginTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Login"
        textField.textColor = .black
        textField.backgroundColor = .lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5.0
        textField.layer.masksToBounds = true
        textField.accessibilityIdentifier = "Login"
        textField.autocorrectionType = .no
        return textField
    }()

    private(set) var passwordTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.textColor = .black
        textField.backgroundColor = .lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5.0
        textField.layer.masksToBounds = true
        textField.accessibilityIdentifier = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpSubviews() {
        let textFieldsWidth : CGFloat = 200.0
        let buttonsWidth : CGFloat = 200.0
        let elementsHeight : CGFloat = 32.0
        let elementsHeightSpacing : CGFloat = 40.0
        backgroundColor = .white
        addSubview(loginTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(signUpButton)
        NSLayoutConstraint.activate([
            loginTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -elementsHeightSpacing),
            loginTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginTextField.widthAnchor.constraint(equalToConstant: textFieldsWidth),
            loginTextField.heightAnchor.constraint(equalToConstant: elementsHeight),
            passwordTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: textFieldsWidth),
            passwordTextField.heightAnchor.constraint(equalToConstant: elementsHeight),
            loginButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: elementsHeightSpacing),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: buttonsWidth),
            loginButton.heightAnchor.constraint(equalToConstant: elementsHeight),
            signUpButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 2*elementsHeightSpacing),
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: buttonsWidth),
            signUpButton.heightAnchor.constraint(equalToConstant: elementsHeight)
        ])
    }
}
