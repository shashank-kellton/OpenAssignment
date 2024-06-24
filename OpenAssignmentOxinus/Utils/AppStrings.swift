//
//  AppStrings.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 24/06/24.
//

import Foundation

enum AppStrings: String {
    
    case noInternetConnection = "Please check your Internet Availability!"
    case nofavFound = "Please add favorites"
    case someThingWentWrong = "Something went worng!"
}

extension AppStrings {
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
