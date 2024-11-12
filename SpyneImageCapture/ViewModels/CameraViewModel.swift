import AVFoundation
import RealmSwift
import UIKit

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    static let shared = CameraViewModel()  // Singleton instance

    private static var sharedSession: AVCaptureSession?
    private var output = AVCapturePhotoOutput()
    
    @Published var isSessionRunning = false
    
    // Computed property for accessing the singleton session
    var session: AVCaptureSession? {
        return CameraViewModel.sharedSession
    }

    private override init() {
        super.init()
        checkCameraPermission()
    }

    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            if !isSessionRunning { startSession() }  // Ensure startSession only called once
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] response in
                if response {
                    self?.startSession()
                } else {
                    print("Camera access denied.")
                }
            }
        case .denied, .restricted:
            print("Camera access denied.")
        @unknown default:
            break
        }
    }

    func startSession() {
        guard !isSessionRunning else {
            print("Session is already running.")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if CameraViewModel.sharedSession == nil {
                CameraViewModel.sharedSession = AVCaptureSession()
            }
            let session = CameraViewModel.sharedSession!

            session.beginConfiguration()

            // Clear existing inputs and outputs
            for input in session.inputs { session.removeInput(input) }
            for output in session.outputs { session.removeOutput(output) }

            // Configure camera input
            guard let camera = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: camera) else {
                print("Error: Unable to get or add camera input.")
                session.commitConfiguration()
                return
            }

            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(self.output) { session.addOutput(self.output) }

            session.commitConfiguration()
            session.startRunning()

            DispatchQueue.main.async {
                self.isSessionRunning = session.isRunning
                print("Camera session started: \(self.isSessionRunning)")
            }
        }
    }

    func capturePhoto() {
        guard isSessionRunning else {
            print("Error: Capture session is not running.")
            return
        }

        let settings = AVCapturePhotoSettings()
        settings.embeddedThumbnailPhotoFormat = [
            AVVideoCodecKey: AVVideoCodecType.jpeg,
            AVVideoWidthKey: 160,
            AVVideoHeightKey: 120
        ]

        output.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }

        guard let data = photo.fileDataRepresentation() else {
            print("Error: Unable to get photo data.")
            return
        }

        let filePath = FileManagerHelper.saveImage(data: data, name: UUID().uuidString)
        saveImageToRealm(data: data, uri: filePath)
    }

    private func saveImageToRealm(data: Data, uri: String) {
        let realm = try! Realm()
        let imageModel = ImageModel()
        imageModel.imageData = data
        imageModel.imageName = uri

        try! realm.write {
            realm.add(imageModel)
        }

        UploadManager().uploadImage(imageModel: imageModel)  // Trigger upload after saving to Realm
    }
}
