import Foundation

class FileManagerHelper {
    static func saveImage(data: Data, name: String) -> String {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directory.appendingPathComponent("\(name).jpg")
        try? data.write(to: fileURL)
        return fileURL.path
    }
}
