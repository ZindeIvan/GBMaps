//
//  SignUpViewController.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/13/21.
//


import UIKit
import RealmSwift

class SignUpViewController : UIViewController {

    // MARK: - Private properties
    
    private lazy var signUpView : SignUpView = {
        return SignUpView()
    }()

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
        signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
    }

    @objc private func signUpButtonAction(sender: UIButton!) {
        
        guard checkTextFields() else { return }
        
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
        let mapViewController = MapViewController()
        mapViewController.modalPresentationStyle = .fullScreen
        mapViewController.modalTransitionStyle = .crossDissolve
        present(mapViewController, animated: true, completion: nil)
    }
    
    private func checkTextFields() -> Bool {
        return getTextFromField(signUpView.loginTextField) != ""
            && getTextFromField(signUpView.passwordTextField) != ""
    }
    
    private func getTextFromField(_ textField : UITextField) -> String {
        return textField.text ?? ""
    }
}
