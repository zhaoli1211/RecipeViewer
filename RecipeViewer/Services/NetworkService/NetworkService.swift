//
//  NetworkService.swift
//  RecipeViewer
//
//  Created by Li Zhao on 2/21/25.
//

import Foundation

actor RecipesFetchService {
    
    private let urlSession: URLSession
        
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func fetchRecipes() async throws -> Recipes? {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // Handle error
            return nil
        }
        
        let decodedItems = try JSONDecoder().decode(Recipes.self, from: data)
        return decodedItems
    }
}
