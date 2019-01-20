//
//  Connectivity.swift
//  Weather-App
//
//  Created by Abdallah Eid on 1/20/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    
    let reachabilityManager = NetworkReachabilityManager()

    func isConnectedToInternet() -> Bool{

        reachabilityManager?.startListening()
        reachabilityManager?.listener = { _ in
            if let isNetworkReachable = self.reachabilityManager?.isReachable,
                isNetworkReachable == true {
                //Internet Available
            } else {
                //Internet Not Available"
            }
        }
    }
    
}
