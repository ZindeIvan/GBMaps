//
//  LoginViewController.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/13/21.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class LoginViewController : UIViewController {

    // MARK: - Private properties
    
    private lazy var loginView : LoginView = {
        return LoginView()
    }()
    
    private lazy var router : LoginRouter = {
        return LoginRouter(controller: self)
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - init

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
        configureLoginBindings()
        loginView.loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
    }

    @objc private func loginButtonAction(sender: UIButton!) {
        
        let user : Results<User>? = RealmService.shared?.loadFromRealm().filter("login == %@", getTextFromField(loginView.loginTextField))
        
        if user?.count == 0 {
            print("Login failed")
        } else {
            if  user?[0].password != getTextFromField(loginView.passwordTextField) {
                print("Wrong password")
            } else {
                UserDefaults.standard.set(true, forKey: "isLogin")
                router.toMap()
            }
        }
    }

    @objc private func signUpButtonAction(sender: UIButton!) {
        router.toSignUp()
    }
    
    private func getTextFromField(_ textField : UITextField) -> String {
        return textField.text ?? ""
    }
    
    private func configureLoginBindings() {
        Observable
            .combineLatest(
                loginView.loginTextField.rx.text,
                loginView.passwordTextField.rx.text
            )
            .map { login, password in
                return !(login ?? "").isEmpty && !(password ?? "").isEmpty
            }
            .bind { [weak self] inputFilled in
                self?.loginView.loginButton.isEnabled = inputFilled
            }
            .disposed(by: disposeBag)
    }
}
