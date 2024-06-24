//
//  AppDelegate.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 21/06/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let dogsBreedScreen = mainStoryboard.instantiateViewController(withIdentifier: "DogsBreedVC") as! DogsBreedVC
                    let navigationController = UINavigationController(rootViewController: dogsBreedScreen)
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
        return true
    }

}

