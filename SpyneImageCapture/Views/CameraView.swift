import SwiftUI
import AVFoundation

struct CameraView: View {
    @ObservedObject private var cameraViewModel = CameraViewModel.shared

    var body: some View {
        VStack {
            CameraPreviewLayerView(session: cameraViewModel.session)  // Ensure session is passed correctly
                .onAppear {
                    cameraViewModel.checkCameraPermission()  // Starts the session if permitted
                }

            Button("Capture Photo") {
                cameraViewModel.capturePhoto()
            }
            .disabled(!cameraViewModel.isSessionRunning)
            .padding()
        }
    }
}
