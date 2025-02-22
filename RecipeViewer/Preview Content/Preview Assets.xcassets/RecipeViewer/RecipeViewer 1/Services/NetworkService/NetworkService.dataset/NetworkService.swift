//
//  NetworkService.swift
//  RecipeViewer
//
//  Created by Li Zhao on 2/21/25.
//

import Foundation

actor RecipesFetchService {
    private var recipes: Recipes?
    
    func fetchRecipes(_ url: String) async throws -> Recipes? {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // Handle error
            return nil
        }
        
        let decodedItems = try JSONDecoder().decode(Recipes.self, from: data)
        self.recipes = decodedItems
        return decodedItems
    }
}
