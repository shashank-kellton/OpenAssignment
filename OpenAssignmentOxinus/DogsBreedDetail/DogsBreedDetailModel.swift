//
//  DogsBreedDetailModel.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 21/06/24.
//

import Foundation

//// MARK: - DogsBreedDetailModel
import Foundation

// MARK: - DogsBreedDetailModel

struct DogsBreedDetailModel: Codable {
    var url: String
    var isLiked: Bool
    let breedName: String

}

struct DogImage: Codable {
    let message: [String]
    let status: String

}

