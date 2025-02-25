//
//  NetworkServiceTests.swift
//  RecipeViewer
//
//  Created by Li Zhao on 2/25/25.
//
@testable import RecipeViewer
import XCTest

class NetworkServiceTests: XCTestCase {
    var recipesService: RecipesFetchService!
    var urlSession: URLSession!
    
    override func setUp() {
        super.setUp()
        
        // Set up URLSession with MockURLProtocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        
        // Initialize ItemService with the mocked URLSession
        recipesService = RecipesFetchService(urlSession: urlSession)
    }
    
    override func tearDown() {
        recipesService = nil
        urlSession = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    func testFetchItems() async {
        // Given
        let jsonData = """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                }
            ]
        }
        """.data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
                    let response = HTTPURLResponse(
                        url: request.url!,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )!
                    return (response, jsonData)
                }
                
                // When
                do {
                    let recipes = try await recipesService.fetchRecipes()
                    XCTAssertNotNil(recipes)
                    XCTAssertEqual(recipes?.recipes.count, 1)
                    XCTAssertEqual(recipes?.recipes.first?.cuisine, "Malaysian")
                    // Then
                } catch {
                    XCTFail("Failed to fetch items: \(error)")
                }
    }
}
