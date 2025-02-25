//
//  ImageLoaderTests.swift
//  RecipeViewer
//
//  Created by Li Zhao on 2/25/25.
//

import XCTest

@testable import RecipeViewer

class ImageLoaderTests: XCTestCase {
    var imageLoader: ImageLoader!
    let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg")!
    let invalidURL = URL(string: "https://invalid-url.com")!
    
    override func setUp() {
        super.setUp()
        imageLoader = ImageLoader()
        imageLoader.clearDiskCache() // Clear disk cache before each test
    }
    
    override func tearDown() {
        imageLoader.clearDiskCache() // Clean up disk cache after each test
        super.tearDown()
    }
    
    // Test memory caching
    func testMemoryCaching() {
        let testImage = UIImage(systemName: "star")!
        imageLoader.memoryCache.setObject(testImage, forKey: testURL as NSURL)
        
        let expectation = self.expectation(description: "Memory cache returns image")
        imageLoader.loadImage(testURL) { image in
            XCTAssertNotNil(image)
            XCTAssertEqual(image, testImage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // Test disk caching
    func testDiskCaching() {
        let testImage = UIImage(systemName: "star")!
        imageLoader.saveImageToDisk(testImage, for: testURL)
        
        let expectation = self.expectation(description: "Disk cache returns image")
        imageLoader.loadImage(testURL) { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // Test image downloading
    func testImageDownloading() {
        let expectation = self.expectation(description: "Image is downloaded")
        imageLoader.loadImage(testURL) { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Test error handling for invalid URL
    func testErrorHandling() {
        let expectation = self.expectation(description: "Invalid URL returns nil")
        imageLoader.loadImage(invalidURL) { image in
            XCTAssertNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
