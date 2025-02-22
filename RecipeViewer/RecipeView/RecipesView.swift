//
//  ContentView.swift
//  RecipeViewer
//
//  Created by Li Zhao on 2/21/25.
//
import SwiftUI

struct RecipesView: View {

    @StateObject private var viewModel = RecipeViewModel()

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
    @ObservedObject var viewModel: RecipeViewModel
    @State private var image: UIImage?
    
    var body: some View {
        HStack {
            // Recipe Image
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
            } else {
                ProgressView()
                    .frame(width: 50, height: 50)
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
        .onAppear {
            // Load image when the row appears
            Task {
                self.image = try await viewModel.loadImage(for: recipe.imageUrlSmall)
            }
        }
    }
}

