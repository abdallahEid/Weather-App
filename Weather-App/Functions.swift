//
//  Functions.swift
//  Weather-App
//
//  Created by Abdallah Eid on 1/15/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

/*
 This class contains the Common Function to be used in any place in the project
*/

import Foundation
import SVProgressHUD
import Alamofire

class Functions {
    static func configureLoadingIndicator(){
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    static func showAlert(message:String, viewController:UIViewController)  {
        let alertController = UIAlertController(title: "Message", message:
            message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }

    static func checkInternet() -> Bool{
        if NetworkReachabilityManager()!.isReachable {
            return true
        } else {
            return false 
        }
    }
    
}
