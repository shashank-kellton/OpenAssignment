//
//  DogsBreedModel.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 21/06/24.
//

import Foundation

// MARK: - DogsBreedModel

struct DogsBreedModel: Codable {
    let message: [String: [String]]
    let status: String
}

struct DogsBreed {
    let breed: String
    let subcategories: [String]
}
