import SwiftUI
import AVFoundation

struct CameraPreviewView: View {
    var session: AVCaptureSession?

    var body: some View {
        ZStack {
            if let session = session {
                CameraPreviewLayerView(session: session)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

import SwiftUI
import AVFoundation

struct CameraPreviewLayerView: UIViewRepresentable {
    var session: AVCaptureSession?

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        setupPreviewLayer(for: view, session: session)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the preview layer's frame to match the view bounds
        if let previewLayer = context.coordinator.previewLayer {
            previewLayer.frame = uiView.bounds
        } else {
            // Set up the preview layer if it hasn’t been initialized
            setupPreviewLayer(for: uiView, session: session)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    private func setupPreviewLayer(for view: UIView, session: AVCaptureSession?) {
        // Configure and add the AVCaptureVideoPreviewLayer
        if let session = session {
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill  // Fill the view
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
            makeCoordinator().previewLayer = previewLayer
        }
    }

    class Coordinator: NSObject {
        var previewLayer: AVCaptureVideoPreviewLayer?
    }
}
