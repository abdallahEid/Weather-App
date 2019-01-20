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

class Functions {
    static func configureLoadingIndicator(){
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultMaskType(.black)
    }
}
