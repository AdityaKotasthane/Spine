import UserNotifications

class NotificationManager {
    static func scheduleNotification(for imageName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Upload Complete"
        content.body = "Image \(imageName) has been uploaded successfully!"

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
