//
//  NotificationScheduller.swift
//  Relax Time
//
//  Created by Mykola Omelianov on 03.01.2023.
//

import Foundation
import UserNotifications
import Cocoa
import SwiftUI

class NotificationScheduller: NSObject  {
    private let id = "stop work hard"
    private let unCenter = UNUserNotificationCenter.current()
    private var interval: TimeInterval = 3
    private var repeated: Bool = false

    func turnOnNotification() {
        setDelegate()
        unCenter.requestAuthorization(options: [.alert,.sound]) { (authorized, error) in
            if authorized {
                print("yep authorized")
            } else if !authorized {
                print("not authorized")
            } else {
                print("got \(error as Any)" )
            }
        }
        unCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                let request = self.request()
                self.unCenter.add(request, withCompletionHandler: { error in
                    print("ok done")
                })
            }
        }
    }
    
    private func setDelegate() {
        if unCenter.delegate == nil {
            unCenter.delegate = self
        }
    }
    
    func setRepeated(repeating: Bool) {
        self.repeated = repeating
    }
    
    func setTime(time: TimeInterval) {
        self.interval = time
    }
    
    func stopReceiveNotifications() {
        self.unCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func request() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = "Wake up bitch!"
        content.subtitle = "Go play tenis"
        content.sound = UNNotificationSound.default
       
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.interval, repeats: self.repeated)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        return request
    }
}

extension NotificationScheduller: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        return completionHandler([.list, .sound])
    }
}
