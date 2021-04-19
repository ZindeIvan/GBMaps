//
//  BaseRouter.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/14/21.
//

import UIKit

class BaseRouter: NSObject {
    private weak var controller: UIViewController?
    
    init(controller: UIViewController){
        self.controller = controller
    }
    
    func show(_ controller: UIViewController) {
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.controller?.show(controller, sender: nil)
    }
    
    func present(_ controller: UIViewController) {
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.controller?.present(controller, animated: true)
    }
    
    func setAsRoot(_ controller: UIViewController) {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = controller
    }
    
}
