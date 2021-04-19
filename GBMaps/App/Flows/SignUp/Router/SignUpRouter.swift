//
//  SignUpRouter.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/14/21.
//

import UIKit

final class SignUpRouter: BaseRouter {
    func toMap() {
        let controller = MapViewController()
        present(controller)
    }
}
