//
//  LoginRouter.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/14/21.
//
import UIKit

final class LoginRouter: BaseRouter {
    func toSignUp() {
        let controller = SignUpViewController()
        present(controller)
    }
    
    func toMap() {
        let controller = MapViewController()
        present(controller)
    }
}
