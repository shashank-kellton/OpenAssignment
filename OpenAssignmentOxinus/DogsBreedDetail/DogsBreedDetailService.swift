//
//  DogsBreedDetailService.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 21/06/24.
//

import Foundation
import Alamofire

class DogsBreedDetailService: DogsBreedDetailProtocol {
    // Call protocol function
    func getDogsBreedDetail(breedName: String?,success: @escaping ([DogsBreedDetailModel]) -> (), failure: @escaping (APIError) -> ()) {
        APIManager.request(API.getDogsBreedDetailURL+(breedName ?? "")+"/images", Constants.baseUrl, method: .get, parameters: [:], encoding: URLEncoding.default, headers: [], completion: { (responseData) in
            do {
                let data:DogImage = try JSONDecoder().decode(DogImage.self, from: responseData)
                let fetchedDogImages: [DogsBreedDetailModel] = data.message.map { DogsBreedDetailModel(url: $0, isLiked: false, breedName: breedName ?? "") }
                success(fetchedDogImages)
            } catch _ {
                debugPrint("Failure Data Parsing Error")
            }
        }) { (errorData) in
            // pass API error model here as per the requirement
            do {
                let error = try JSONDecoder().decode(APIError.self, from: errorData)
                failure(error)
            } catch _ {
                debugPrint("Failure Data Parsing Error")
            }
        }
    }

}
