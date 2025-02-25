//
//  RemoteImageView.swift
//  RecipeViewer
//
//  Created by Li Zhao on 2/21/25.
//

import SwiftUICore
import UIKit
import SwiftUI

struct RemoteImageView: View {
    @StateObject private var loader = ImageLoaderViewModel()
    let url: URL
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image(uiImage: UIImage(systemName: "photo")!).resizable()
            }
        }
        .onAppear { loader.load(url: url) }
        .onDisappear { loader.cancel() }
    }
}

// MARK: - View Model
final class ImageLoaderViewModel: ObservableObject {
    @Published var image: UIImage?
    private var uuid: UUID?
    private let loader = ImageLoader()
    
    func load(url: URL) {
        uuid = loader.loadImage(url) { [weak self] image in
            self?.image = image
        }
    }
    
    func cancel() {
        if let uuid = uuid {
            loader.cancelRequest(uuid)
        }
    }
}
