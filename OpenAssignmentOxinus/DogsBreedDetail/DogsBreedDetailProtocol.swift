//
//  DogsBreedDetailProtocol.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 21/06/24.
//

import Foundation

protocol DogsBreedDetailProtocol {
    func getDogsBreedDetail(breedName:String?, success: @escaping(_ success: [DogsBreedDetailModel]) -> (), failure: @escaping(_ failureData: APIError) -> ())
}
