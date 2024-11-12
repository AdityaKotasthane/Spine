import SwiftUI
import RealmSwift

struct ImageRowView: View {
    @ObservedRealmObject var imageModel: ImageModel

    var body: some View {
        HStack {
            if let data = imageModel.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 50, height: 50)
            } else {
                Text("Image not available")
            }
            Text(imageModel.uploadStatus)
            ProgressView(value: imageModel.uploadProgress, total: 1.0)
                .frame(width: 100)
        }
    }
}
