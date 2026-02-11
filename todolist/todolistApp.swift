import SwiftUI

@main
struct todolistApp: App {
    var body: some Scene {
        WindowGroup {
            BottomBarView()
                .onAppear {
                    NotificationManager.shared.requestNotificationPermission()
                }
        }
    }
}
