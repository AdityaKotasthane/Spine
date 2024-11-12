import RealmSwift
import Foundation

class ImageModel: Object, Identifiable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var imageData: Data?
    @objc dynamic var imageName: String = ""
    @objc dynamic var captureDate: Date = Date()
    @objc dynamic var uploadStatus: String = "Pending"
    @objc dynamic var uploadProgress: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
