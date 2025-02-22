//
//  ImageLoadingService.swift
//  RecipeViewer
//
//  Created by Li Zhao on 2/21/25.
//


import Foundation
import UIKit
import SwiftUI

actor ImageLoader {
    private var inMemoryCache = NSCache<NSString, UIImage>()
    private let diskCacheDirectory: URL
    
    init() {
        // Create a directory for disk caching
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheDirectory = cacheDirectory.appendingPathComponent("ImageCache")
        
        if !fileManager.fileExists(atPath: diskCacheDirectory.path) {
            try? fileManager.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func loadImage(from url: URL) async throws -> UIImage {
        let cacheKey = url.absoluteString as NSString
        
        // Check in-memory cache
        if let cachedImage = inMemoryCache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        // Check disk cache
        if let diskCachedImage = loadImageFromDisk(for: cacheKey) {
            inMemoryCache.setObject(diskCachedImage, forKey: cacheKey)
            return diskCachedImage
        }
        
        // Download image
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        // Cache in memory and disk
        inMemoryCache.setObject(image, forKey: cacheKey)
        try saveImageToDisk(image, for: cacheKey)
        
        return image
    }
    
    private func loadImageFromDisk(for key: NSString) -> UIImage? {
        let fileURL = diskCacheDirectory.appendingPathComponent(key as String)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
    
    private func saveImageToDisk(_ image: UIImage, for key: NSString) throws {
        let fileURL = diskCacheDirectory.appendingPathComponent(key as String)
        guard let data = image.pngData() else { return }
        try data.write(to: fileURL)
    }
}
