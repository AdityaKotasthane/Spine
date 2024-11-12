import Foundation
import RealmSwift

class ImageUploadViewModel: ObservableObject {
    private let realm = try! Realm()
    
    func retryFailedUploads() {
        let failedImages = realm.objects(ImageModel.self).filter("uploadStatus == 'Failed'")
        failedImages.forEach { image in
            UploadManager().uploadImage(imageModel: image)
        }
    }
    
    
}
