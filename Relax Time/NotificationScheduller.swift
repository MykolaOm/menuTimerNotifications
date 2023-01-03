//
//  NotificationScheduller.swift
//  Relax Time
//
//  Created by Mykola Omelianov on 03.01.2023.
//

import Foundation
import UserNotifications

class NotificationScheduller: NSObject  {
    private let id = "stop work hard"
    private let unCenter = UNUserNotificationCenter.current()
    private var interval: TimeInterval = 3 {
        didSet {
            if interval < 60.0 && repeated == true {
                interval = 60
            }
        }
    }
    private var repeated: Bool = false {
        didSet {
            if repeated {
                if interval < 60 {
                    interval = 60
                }
            }
        }
    }

    //MARK: Controlls
    
    func turnOnNotification() {
        setDelegate()
        requestAuth()
        setNotification()
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
    
    // MARK: Private methods
    private func requestAuth() {
        unCenter.requestAuthorization(options: [.alert,.sound]) { (authorized, error) in
            if authorized {
                print("yep authorized")
            } else if !authorized {
                print("not authorized")
            } else {
                print("got \(error as Any)" )
            }
        }
    }
    
    private func setNotification() {
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
    
    private func request() -> UNNotificationRequest {
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
