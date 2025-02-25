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
class RecipesViewModel: ObservableObject {
    
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    
    private let fetchService = RecipesFetchService()

    func fetchRecipes() async {
        isLoading = true
        error = nil
        
        do {
            let fetchedItems = try await fetchService.fetchRecipes()
            self.recipes = fetchedItems?.recipes ?? []
            self.recipes.sort(by: { $0.cuisine < $1.cuisine })
        } catch {
            self.error = error
            print("Error fetching items: \(error)")
        }
        
        isLoading = false
    }
}
