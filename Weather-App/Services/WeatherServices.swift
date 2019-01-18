//
//  WeatherServices.swift
//  Weather-App
//
//  Created by Abdallah Eid on 1/17/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

import Foundation
import Alamofire

class WeatherServices {
    
    func getTodayWeather(cityName: String, completionHandlerForGetTodayWeather: @escaping(_ success:Bool,_ data: Weather?,_ error:String?) ->  Void ){
        let url = Constants.BASEURL 
        let parameters:Parameters = [
            "appid": Constants.APPID,
            "q": cityName
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
            
//            if let json = response.result.value {
//
//            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                do {
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    completionHandlerForGetTodayWeather(true,weather,nil)
                }
                catch{
                    completionHandlerForGetTodayWeather(false,nil,"Failed to decode data")
                    return
                }
            }
        }
    }
    
    class func sharedInstance() -> WeatherServices {
        struct singleton {
            static let sharedInstance = WeatherServices()
        }
        return singleton.sharedInstance
    }
}
