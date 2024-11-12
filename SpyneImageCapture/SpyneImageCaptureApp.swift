import SwiftUI

@main
struct SpyneImageCaptureApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    CameraView()
                    NavigationLink("View Captured Images", destination: ImageListView())
                }
            }
        }
    }
}
