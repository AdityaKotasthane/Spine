import Foundation
import RealmSwift

class UploadManager: NSObject, URLSessionTaskDelegate {
    private var session: URLSession!
    
    override init() {
        super.init()
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
    }

    func uploadImage(imageModel: ImageModel) {
        guard let url = URL(string: "https://www.clippr.ai/api/upload"),
              let data = imageModel.imageData else {
            print("Upload failed: URL or image data is nil")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")

        let task = session.uploadTask(with: request, from: data) { responseData, response, error in
            let realm = try! Realm()
            try! realm.write {
                imageModel.uploadStatus = error == nil ? "Completed" : "Failed"
                imageModel.uploadProgress = error == nil ? 1.0 : 0.0
            }

            if error == nil {
                NotificationManager.scheduleNotification(for: imageModel.imageName)
                print("Upload completed successfully for image: \(imageModel.imageName)")
            } else {
                print("Upload failed for image: \(imageModel.imageName), Error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
        print("Upload task started for image: \(imageModel.imageName)")
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        
        DispatchQueue.main.async {
            let realm = try! Realm()
            try! realm.write {
                (task.originalRequest?.httpBody as? ImageModel)?.uploadProgress = progress
            }
            print("Upload progress for image \(task.originalRequest?.url?.lastPathComponent ?? ""): \(progress * 100)%")
        }
    }
}
