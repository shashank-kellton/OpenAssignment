//
//  FavoriteClass.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 24/06/24.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private var favorites: [DogsBreedDetailModel] = []
    
    private init() {}
    
    func addFavorite(dogsBreedDetailModel: DogsBreedDetailModel) {
        if !favorites.contains(where: { $0.url == dogsBreedDetailModel.url }) {
            favorites.append(dogsBreedDetailModel)
        }
    }
    
    func removeFavorite(dogsBreedDetailModel: DogsBreedDetailModel) {
        if let index = favorites.firstIndex(where: { $0.url == dogsBreedDetailModel.url }) {
            favorites.remove(at: index)
        }
    }
    
    func getFavorites() -> [DogsBreedDetailModel] {
        return favorites
    }
    
    func getFavorites(for breedName: String) -> [DogsBreedDetailModel] {
        return favorites.filter { $0.breedName == breedName }
    }

}
