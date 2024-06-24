//
//  Alert.swift
//  OpenAssignmentOxinus
//
//  Created by shashankMishra on 24/06/24.
//

import TTGSnackbar

class Alert {
    
    class func showSnackBar(message:String){
        DispatchQueue.main.async {
            let snackbar = TTGSnackbar.init(message: message, duration: .middle)
            snackbar.messageTextColor = UIColor.white
            snackbar.show()

        }
    }
    
}
