//
//  ContentView.swift
//  RecipeViewer
//
//  Created by Li Zhao on 2/21/25.
//
import SwiftUI

struct RecipesView: View {

    @StateObject private var viewModel = RecipesViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let _ = viewModel.error { // Error handling
                    Text("Something went wrong, please try again later.")
                        .foregroundColor(.red)
                } else {
                    if viewModel.recipes.isEmpty { // Empty state
                        Text("No recipes found.")
                    } else {
                        List(viewModel.recipes, id: \.uuid) { recipe in
                            RecipeRow(recipe: recipe, viewModel: viewModel)
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                await viewModel.fetchRecipes()
            }
        }
    }
}

struct RecipeRow: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipesViewModel
    
    var body: some View {
        HStack {
            // Recipe Image
            if let url = URL(string: recipe.imageUrlSmall) {
                RemoteImageView(url: url)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
            }
            // Recipe Details
            VStack(alignment: .leading) {
                Text(recipe.cuisine)
                    .font(.headline)
                Text(recipe.name)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

