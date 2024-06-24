//
//  DogsBreedService.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 21/06/24.
//

import Foundation
import Alamofire

class DogsBreedService: DogsBreedProtocol {
    // Call protocol function

    func getDogsBreed(postData: [String : Any], success: @escaping (DogsBreedModel) -> (), failure: @escaping (APIError) -> ()) {
        //        SVProgressHUD.show()
        APIManager.request(API.getDogsBreedURL, Constants.baseUrl, method: .get, parameters: postData, encoding: URLEncoding.default, headers: [], completion: { (responseData) in
            do {
                let data = try JSONDecoder().decode(DogsBreedModel.self, from: responseData)
                success(data)
            } catch _ {
                debugPrint("Failure Data Parsing Error")
            }
        }) { (errorData) in
            // pass API error model here. its for dummy only

            do {
                let error = try JSONDecoder().decode(APIError.self, from: errorData)
                failure(error)
            } catch _ {
                debugPrint("Failure Data Parsing Error")
            }
        }
    }

}
