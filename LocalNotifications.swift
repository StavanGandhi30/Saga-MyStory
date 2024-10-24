//
//  LocalNotifications.swift
//  Saga
//
//  Created by Stavan Gandhi on 7/21/22.
//

import CoreData
import SwiftUI
import UserNotifications

struct NotificationObject{
    var identifier: String
    
    var title: String
    var body: String
    var time: Date
    var repeats: Bool
}

class Notification: ObservableObject{
    @Published var notifications = [NotificationObject]()
    @Published var permission: UNAuthorizationStatus = .notDetermined
    
    init(){
        self.getDailyNotifications()
        self.getNotificationSetting()
    }
    
    func reload(){
        self.getDailyNotifications()
        self.getNotificationSetting()
    }
    
    func requestAuth(completion: @escaping ((String, Bool) -> Void)){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){ success, error in
            if success {
                completion("authorization granted" , true)
            } else if let error = error {
                print("\(error.localizedDescription)")
                completion(String(describing: error.localizedDescription) , false)
            }
        }
    }
    
    func scheduleNotification(identifier: String, body: String, time: [String:Int], repeats: Bool = false) {
        self.getAllIdentifier { identifierList in
            if !identifierList.contains(identifier){
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    switch settings.authorizationStatus {
                    case .notDetermined:
                        print("Notifications not authorized")
                    case .authorized, .provisional:
                        self.addNotification(
                            identifier: identifier,
                            body: body,
                            time: [
                                "Hour" : time["Hour"]!,
                                "Minute" : time["Minute"]!,
                                "Seconds" : time["Seconds"]!
                            ],
                            repeats: repeats
                        )
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func updateNotification(identifier: String, body: String, time: [String:Int], repeats: Bool = false){
        cancelNotificationWithId(identifier: identifier)
        scheduleNotification(
            identifier: identifier,
            body: body,
            time: [
                "Hour" : time["Hour"]!,
                "Minute" : time["Minute"]!,
                "Seconds" : time["Seconds"]!
            ],
            repeats: repeats
        )
    }
    
    func cancelNotificationWithId(identifier: String){
        var id: [String] = []
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == identifier {
                    id.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
        }
    }
    
    func cancelAllNotification(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All Notification is deleted")
    }
    
    func getDailyNotifications(){
        self.notifications = []
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            for item in notifications {
                let identifier = item.identifier
                
                guard let trigger = item.trigger as? UNCalendarNotificationTrigger else { return }
                
                guard let time = trigger.nextTriggerDate() else{ return }
                
                let title = item.content.title
                let body = item.content.body
                let repeats = trigger.repeats
                
                self.notifications.append(
                    NotificationObject(identifier: identifier, title: title, body: body, time: time, repeats: repeats)
                )
            }
        }
    }
}

extension Notification{
    private func addNotification(identifier: String, body: String, time: [String:Int], repeats: Bool){
        let content = UNMutableNotificationContent()
        content.title = "Saga"
        content.body = body
        content.sound = UNNotificationSound.default
        
        let open = UNNotificationAction(identifier: "open", title: "Open", options: .foreground)
        let cancel = UNNotificationAction(identifier: "cancel", title: "Cancel", options: .destructive)
        let categories = UNNotificationCategory(identifier: "action", actions: [open, cancel], intentIdentifiers: [])
        UNUserNotificationCenter.current().setNotificationCategories([categories])
        content.categoryIdentifier = "action"
        
        var dateComponents = DateComponents()
        dateComponents.hour = time["Hour"]!
        dateComponents.minute = time["Minute"]!
        dateComponents.second = time["Seconds"]!
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            guard error == nil else {
                return
            }
        }
    }
    
    private func getAllIdentifier(completion: @escaping ([String]) -> Void){
        var identifierList: [String] = []
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            DispatchQueue.main.async {
                for item in notifications {
                    let identifier = item.identifier
                    
                    identifierList.append(identifier)
                }
                completion(identifierList)
            }
        }
    }
    
    func getNotificationSetting(){
        UNUserNotificationCenter.current().getNotificationSettings { permissionStatus in
            switch permissionStatus.authorizationStatus {
            case .authorized:
                self.permission = .authorized
            case .denied:
                self.permission = .denied
            case .notDetermined:
                self.permission = .notDetermined
            case .provisional:
                self.permission = .notDetermined
            case .ephemeral:
                self.permission = .ephemeral
            @unknown default:
                self.permission = .notDetermined
            }
        }
    }
}


extension Notification {
    func addSystemNotifications(){
        self.scheduleNotification(
            identifier: "SagaLocalNotificationMorning",
            body: "Let's start our day and journal with \"Today I am excited to…\"",
            time: [
                "Hour" : 8,
                "Minute" : 00,
                "Seconds" : 00
            ],
            repeats: true
        )
        
        self.scheduleNotification(
            identifier: "SagaLocalNotificationEvening",
            body: "Hey, How is your day going so far?",
            time: [
                "Hour" : 15,
                "Minute" : 00,
                "Seconds" : 00
            ],
            repeats: true
        )
        
        self.scheduleNotification(
            identifier: "SagaLocalNotificationNight",
            body: "Let's complete today's journal with \"What would I like to accomplish more of tomorrow?\"",
            time: [
                "Hour" : 19,
                "Minute" : 00,
                "Seconds" : 00
            ],
            repeats: true
        )
    }
}
