//
//  DogsBreedProtocol.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 21/06/24.
//

import Foundation

protocol DogsBreedProtocol {
    func getDogsBreed(postData:[String:Any], success: @escaping(_ success: DogsBreedModel) -> (), failure: @escaping(_ failureData: APIError) -> ())
}
