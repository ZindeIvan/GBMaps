//
//  MapRouter.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/16/21.
//

import UIKit

final class MapRouter: BaseRouter {
    func toLogin() {
        let controller = LoginViewController()
        setAsRoot(controller)
    }
}
