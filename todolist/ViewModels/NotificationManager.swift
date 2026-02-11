import Foundation
import UserNotifications

final class NotificationManager{
    
    static let shared = NotificationManager()
    
    private init(){
        
    }
    
    func requestNotificationPermission(){
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert,.sound,.badge]){ granted, error in
                if let error = error{
                    print("Error requesting permission", error)
                }
                print("Permission granted", granted)
            }
    }
    
    func scheduleNotification(
        id: String,
        title: String,
        body: String,
        date: Date,
        hoursBefore: Int = 0
    ) {
        guard let triggerDate = Calendar.current.date(
            byAdding: .hour,
            value: -hoursBefore,
            to: date
        )else {return}
        
        guard triggerDate > Date() else {return}
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let tiggerDate = Calendar.current.dateComponents(
            [.year, . month, .day, .hour, .minute],
            from: triggerDate
        )
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: tiggerDate,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeNotification(id: String) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func removeAllNotification(){
        UNUserNotificationCenter.current()
            .removeAllPendingNotificationRequests()
    }
}
