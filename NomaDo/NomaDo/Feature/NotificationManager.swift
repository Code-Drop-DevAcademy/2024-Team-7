//
//  NotificationView.swift
//  NomaDo
//
//  Created by Seo-Jooyoung on 6/15/24.
//

import SwiftUI
import UserNotifications
import CoreLocation
 
class NotificationManager {
    static let instance = NotificationManager()
    private init() {}
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                print(success)
                completion(success)
            }
        }
    }
    
    func scheduleNotification(trigger: UNNotificationTrigger) {
        let content = UNMutableNotificationContent()
        content.title = "NomaDo"
        content.subtitle = "1분 뒤, 스트레칭을 시작합니다! 함께 해 볼까요?"
        content.sound = .default
        content.badge = 1
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Notification scheduled")
            }
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func resetBadgeCount() {
        UNUserNotificationCenter.current().setBadgeCount(0, withCompletionHandler: nil)
    }
}
