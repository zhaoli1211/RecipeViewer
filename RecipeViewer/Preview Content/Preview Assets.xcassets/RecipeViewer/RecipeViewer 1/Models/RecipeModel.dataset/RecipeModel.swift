//
//  RecipeModel.swift
//  RecipeViewer
//
//  Created by Li Zhao on 2/21/25.
//

import Foundation

struct Recipes: Decodable {
    let recipes: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case recipes
    }
    
}

struct Recipe: Decodable {
    let cuisine: String
    let name: String
    let imageUrlSmall: String
    let uuid: String
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case imageUrlSmall = "photo_url_small"
        case uuid
    }
}
