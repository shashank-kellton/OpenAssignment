//
//  DogsBreedViewModel.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 21/06/24.
//

import Foundation

class DogsBreedViewModel {

    private let service: DogsBreedProtocol

    private var model: [DogsBreedModel] = [DogsBreedModel]() {
        didSet {
            self.count = self.model.count
        }
    }
    
    var apiErrorModel:APIError?
    var dogsBreedModel:DogsBreedModel?
    var sections = [DogsBreed]()
    var breedKeys = [String]() // List to maintain the order of keys


    /// Count your data in model
    var count: Int = 0

    //MARK: -- Network checking

    /// Define networkStatus for check network connection
    var networkStatus = Reach().connectionStatus()

    /// Define boolean for internet status, call when network disconnected
    var isDisconnected: Bool = false {
        didSet {
            self.alertMessage = "No network connection. Please connect to the internet"
            self.internetConnectionStatus?()
        }
    }

    //MARK: -- UI Status

    /// Update the loading status, use HUD or Activity Indicator UI
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    /// Showing alert message, use UIAlertController or other Library
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    /// Define selected model
    var selectedObject: DogsBreedModel?

    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?
    var dogsBreedAPISuccess: (() -> ())?

    

    init(withReport serviceProtocol: DogsBreedProtocol = DogsBreedService() ) {
        self.service = serviceProtocol

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()

    }

    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }

}

extension DogsBreedViewModel {
    
    func getDogsBreedApi(data:[String:Any]){
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.getDogsBreed(postData: [:], success: {(data) in
                self.dogsBreedModel = data
                if let dogBreeds = self.dogsBreedModel {
                    for (breed, subcategories) in dogBreeds.message {
                        self.sections.append(DogsBreed(breed: breed.capitalized, subcategories: subcategories))
                        self.breedKeys.append(breed) // Maintain the order of keys
                    }
                }
                self.dogsBreedAPISuccess?()
                self.isLoading = false
            }) { (Error) in
                self.serverErrorStatus?()
                self.isLoading = false
            }
        default:
            break
        }
    }

}
