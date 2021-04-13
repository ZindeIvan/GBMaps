//
//  LoginViewController.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/13/21.
//

import UIKit
import RealmSwift

class LoginViewController : UIViewController {

    // MARK: - Private properties
    
    private lazy var loginView : LoginView = {
        return LoginView()
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    
    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private methods
    
    private func configureUI() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
    }

    @objc private func loginButtonAction(sender: UIButton!) {
        
        guard checkTextFields() else { return }
        
        let user : Results<User>? = RealmService.shared?.loadFromRealm().filter("login == %@", getTextFromField(loginView.loginTextField))
        
        if user?.count == 0 {
            print("Login failed")
        } else {
            if  user?[0].password != getTextFromField(loginView.passwordTextField) {
                print("Wrong password")
            } else {
                UserDefaults.standard.set(true, forKey: "isLogin")
                let mapViewController = MapViewController()
                mapViewController.modalPresentationStyle = .fullScreen
                mapViewController.modalTransitionStyle = .crossDissolve
                present(mapViewController, animated: true, completion: nil)
            }
        }
    }

    @objc private func signUpButtonAction(sender: UIButton!) {
        let signUpViewController = SignUpViewController()
        signUpViewController.modalPresentationStyle = .fullScreen
        signUpViewController.modalTransitionStyle = .crossDissolve
        present(signUpViewController, animated: true, completion: nil)
    }
    
    private func checkTextFields() -> Bool {
        return getTextFromField(loginView.loginTextField) != ""
            && getTextFromField(loginView.passwordTextField) != ""
    }
    
    private func getTextFromField(_ textField : UITextField) -> String {
        return textField.text ?? ""
    }
}
