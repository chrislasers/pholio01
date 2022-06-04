//
//  LocalNotificationManager.swift
//  pholio01
//
//  Created by Chris  Ransom on 10/1/21.
//  Copyright © 2021 Chris Ransom. All rights reserved.
//

import Foundation
import UserNotifications


struct LocalNotificationManager {
    
    
    
    static func autherizeLocalNotifications(viewController: UIViewController){
        
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound, .badge]) { (granted, error)
            in
            guard error == nil else {
                print(" Error: \(String(describing: error?.localizedDescription))")
                return
            }
            if granted {
                print("Notofications Authorized Granted")
            } else {
                DispatchQueue.main.async {
                    
                    viewController.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open the Settings app, select PHOLLIO > Notifications > Allow Notifications")
                print("Notifications Denied")
                
            }
            }
        }
    }
    
    
    static func isAuthorized(completed: @escaping (Bool)->() ) {
        
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound, .badge]) { (granted, error)
            in
            guard error == nil else {
                print(" Error: \(String(describing: error?.localizedDescription))")
                completed(false)
                return
            }
            if granted {
                print("Notofications Authorized Granted")
                completed(true)

            } else {
                print("Notifications Denied")
                completed(false)

                
            }
            }
        }
    
  
    
    static func setCalenderNotifications(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
        
        
        //Create Content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        // create trigger
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //create request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        // register request with notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            
            if let error = error {
                
                print(" Error: \(String(describing: error.localizedDescription))")
            } else {
                
                print("Notification scheduled \(notificationID), title: \(content.title)")
            }
        }
        
        return notificationID
    }
    
    
    
}
