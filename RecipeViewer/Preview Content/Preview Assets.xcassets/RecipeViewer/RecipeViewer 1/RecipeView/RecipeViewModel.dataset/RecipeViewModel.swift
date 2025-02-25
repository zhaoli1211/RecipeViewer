//
//  RecipeViewModel.swift
//  RecipeViewer
//
//  Created by Li Zhao on 2/21/25.
//

import Foundation
import Combine
import UIKit

@MainActor
class RecipeViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    let url =  "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    private let fetchService = RecipesFetchService()
    private let imageLoader = ImageLoader()

    func fetchRecipes() async {
        isLoading = true
        error = nil
        
        do {
            let fetchedItems = try await fetchService.fetchRecipes(url)
            self.recipes = fetchedItems?.recipes ?? []
            self.recipes.sort(by: { $0.cuisine < $1.cuisine })
        } catch {
            self.error = error
            print("Error fetching items: \(error)")
        }
        
        isLoading = false
    }
    
    func loadImage(for url: String) async throws -> UIImage? {
        if let url = URL(string: url) {
            return try await imageLoader.loadImage(from: url)
        }
        return UIImage(systemName: "photo")
    }
}
