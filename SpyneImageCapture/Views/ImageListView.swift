import SwiftUI
import RealmSwift

struct ImageListView: View {
    @ObservedResults(ImageModel.self) var images
    
    var body: some View {
        List(images) { image in
            ImageRowView(imageModel: image)
        }
    }
}
