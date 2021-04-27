//
//  NotificationManager.swift
//  GBMaps
//
//  Created by Зинде Иван on 4/27/21.
//

import Foundation
import UserNotifications

final class NotificationManager: NSObject {
    static let instance = NotificationManager()
    
    private var notificationGranted : Bool?
    
    private override init() {
        super.init()
    }
    
    func configureNotificationManager() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                self.notificationGranted = false
                return
            }
            self.notificationGranted = true
        }
    }
    
    
    func makeNotificationContent(title: String,
                                 subtitle: String,
                                 body: String,
                                 badge : NSNumber?) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badge
        return content
    }
    
    func makeIntervalNotificatioTrigger(timeInterval: TimeInterval, repeats: Bool) -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: repeats
        )
    }
    
    func sendNotificatioRequest(content: UNNotificationContent, trigger: UNNotificationTrigger, id: String) {
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        let center = UNUserNotificationCenter.current()
        guard notificationGranted ?? false else { return }
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func makeReturnToAppNotification() {
        let content = makeNotificationContent(title: "GET BACK",
                                              subtitle: "30 minutes AFK",
                                              body: "Please get back to App",
                                              badge: nil)
        let triger = makeIntervalNotificatioTrigger(timeInterval: 30*60,
                                                    repeats: false)
        let id = "returnToAppNotification_ID"
        sendNotificatioRequest(content: content, trigger: triger, id: id)
    }
}
