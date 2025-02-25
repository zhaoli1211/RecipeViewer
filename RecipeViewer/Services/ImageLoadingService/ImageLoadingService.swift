//
//  ImageLoadingService.swift
//  RecipeViewer
//
//  Created by Li Zhao on 2/21/25.
//


import Foundation
import UIKit
import SwiftUI

class ImageLoader: ObservableObject {
    let memoryCache = NSCache<NSURL, UIImage>()
    private var currentRequests = [UUID: URLSessionDataTask]()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        // Create a cache directory if it doesn't exist
        let directories = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = directories[0].appendingPathComponent("ImageCache")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func loadImage(_ url: URL, completion: @escaping (UIImage?) -> Void) -> UUID? {
        // Check memory cache first
        if let cachedImage = memoryCache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return nil
        }
        
        // Check disk cache
        if let diskCachedImage = loadImageFromDisk(for: url) {
            memoryCache.setObject(diskCachedImage, forKey: url as NSURL) // Populate memory cache
            completion(diskCachedImage)
            return nil
        }
        
        // Download the image if not cached
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer { self?.currentRequests.removeValue(forKey: uuid) }
            
            guard let data = data, let image = UIImage(data: data), error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            // Cache the image in memory and disk
            self?.memoryCache.setObject(image, forKey: url as NSURL)
            self?.saveImageToDisk(image, for: url)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        currentRequests[uuid] = task
        task.resume()
        
        return uuid
    }
    
    func cancelRequest(_ uuid: UUID) {
        currentRequests[uuid]?.cancel()
        currentRequests.removeValue(forKey: uuid)
    }
    
    // MARK: - Disk Caching Helpers
    
    func saveImageToDisk(_ image: UIImage, for url: URL) {
        let filePath = cacheDirectory.appendingPathComponent(url.pathComponents[url.pathComponents.count - 2])
        if let data = image.pngData() {
            try? data.write(to: filePath)
        }
    }
    
    func loadImageFromDisk(for url: URL) -> UIImage? {
        let filePath = cacheDirectory.appendingPathComponent(url.pathComponents[url.pathComponents.count - 2])
        guard fileManager.fileExists(atPath: filePath.path),
              let data = try? Data(contentsOf: filePath),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    // Optional: Clear disk cache
    func clearDiskCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
}
