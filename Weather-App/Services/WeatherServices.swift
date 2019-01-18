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
        
        let url = Constants.BASEURL + "/weather"
        let parameters:Parameters = [
            "appid": Constants.APPID,
            "q": cityName
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if let data = response.data {
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
    
    func getForecast(cityName: String, completionHandlerForGetForecast: @escaping(_ success:Bool,_ data: [Weather]?,_ error:String?) ->  Void ){
    
        let url = Constants.BASEURL + "/forecast"
        let parameters:Parameters = [
            "appid": Constants.APPID,
            "q": cityName
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            
            if response.result.error == nil {
                if let object = response.result.value as? [String:Any] {
                    guard let data = try? JSONSerialization.data(withJSONObject: object["list"]!, options: []) else {
                        return
                    }
                    
                    do {
                        let weathers = try JSONDecoder().decode([Weather].self, from: data)
                        completionHandlerForGetForecast(true,weathers,nil)
                    }
                    catch{
                        completionHandlerForGetForecast(false,nil,"Failed to decode data")
                        return
                    }
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
