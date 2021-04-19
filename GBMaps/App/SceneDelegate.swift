//
//  SceneDelegate.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/6/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var blurredSecureView: UIView?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let winScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: winScene)
        let controller : UIViewController
        if UserDefaults.standard.bool(forKey: "isLogin") {
            controller = MapViewController()
        } else {
            controller = LoginViewController()
        }
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        blurredSecureView?.removeFromSuperview()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        let blurredImage = applyBlur(on: createScreenshoot() ?? UIImage(), whithBlurFactor: 5.0)
        blurredSecureView = UIImageView(image: blurredImage)
        window?.addSubview(blurredSecureView!)
    }
    
    func createScreenshoot() -> UIImage? {
        UIGraphicsBeginImageContext(window?.screen.bounds.size ?? CGSize())
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        window?.layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func applyBlur(on image: UIImage, whithBlurFactor blurFactor: CGFloat) -> UIImage? {
        guard let inputImage = CIImage(image: image) else { return nil }
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(blurFactor, forKey: kCIInputRadiusKey)
        guard let outputImage = filter?.outputImage else { return nil }
        return UIImage(ciImage: outputImage)
    }


}

