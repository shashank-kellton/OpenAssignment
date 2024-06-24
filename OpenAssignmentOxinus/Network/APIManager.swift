

import Foundation
import Alamofire
import Photos

struct APIManager {
    
    //    static var manager: Session!
    public static let manager: Session = {
        let configuration = URLSessionConfiguration.default
        //        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
    
    /// GET FROM API
    ///
    /// - Parameters:
    ///   - url: URL API
    ///   - method: methods
    ///   - parameters: parameters
    ///   - encoding: encoding
    ///   - headers: headers
    ///   - completion: completion
    ///   - failure: failure
    static func request(_ url: String, _ base_url: String?,method: HTTPMethod, parameters: Parameters, encoding: ParameterEncoding, headers: HTTPHeaders, completion: @escaping (_ response: Data) ->(), failure: @escaping (_ failure: Data) -> ()) {
        
        let apiURL = (base_url ?? Constants.baseUrl) + url
        print("-- URL API: \(apiURL) \n\n-- headers: \(headers) \n\n-- Parameters: \(parameters)")
        
        manager.request(
            apiURL,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers).responseString(
                queue: DispatchQueue.main,
                encoding: String.Encoding.utf8) { response in
                    
                    print("--\n \n CALLBACK RESPONSE: \(response)")
                    
                    if response.response?.statusCode == 200 {
                        guard let callback = response.data else {
                            print("Data Parsing Error")
                            return
                        }
                        completion(callback)
                    }
                    else if response.response?.statusCode == 401 {
                        // add function automatically logout app
                        guard let failureData = response.data else {
                            return
                        }
                        failure(failureData)
                    }
                    else if response.response?.statusCode == 400 {
                        // add function to call register api
                        guard let failureData = response.data else {
                            return
                        }
                        failure(failureData)
                        
                        
                    } else if response.response?.statusCode == 202 {
                        // call register api //
                        completion(response.data!)
                    }
                    else {
                        guard let failureData = response.data else {
                            return
                        }
                        failure(failureData)
                    }
                    
                }
        
    }
}
    
