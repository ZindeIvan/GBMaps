//
//  SignUpViewController.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/13/21.
//


import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class SignUpViewController : UIViewController {

    // MARK: - Private properties
    
    private lazy var signUpView : SignUpView = {
        return SignUpView()
    }()
    
    private lazy var router : SignUpRouter = {
        return SignUpRouter(controller: self)
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
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private methods
    
    private func configureUI() {
        configureSignUpBindings()
        signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
    }

    @objc private func signUpButtonAction(sender: UIButton!) {
        
        let user : Results<User>? = RealmService.shared?.loadFromRealm().filter("login == %@", getTextFromField(signUpView.loginTextField))
        
        if user?.count == 0 {
            let newUser = User()
            newUser.login = getTextFromField(signUpView.loginTextField)
            newUser.password = getTextFromField(signUpView.passwordTextField)
            try? RealmService.shared?.saveInRealm(object: newUser)
        } else {
            guard let oldUser = user?[0] else { return }
            guard oldUser.password != getTextFromField(signUpView.passwordTextField) else { return }
            oldUser.password = getTextFromField(signUpView.passwordTextField)
            try? RealmService.shared?.saveInRealm(object: oldUser)
        }
        
        UserDefaults.standard.set(true, forKey: "isLogin")
        router.toMap()
    }
    
    private func getTextFromField(_ textField : UITextField) -> String {
        return textField.text ?? ""
    }
    
    private func configureSignUpBindings() {
        Observable
            .combineLatest(
                signUpView.loginTextField.rx.text,
                signUpView.passwordTextField.rx.text
            )
            .map { login, password in
                return !(login ?? "").isEmpty && !(password ?? "").isEmpty
            }
            .bind { [weak self] inputFilled in
                self?.signUpView.signUpButton.isEnabled = inputFilled
            }
            .disposed(by: disposeBag)
    }
}
