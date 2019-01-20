//
//  Constants.swift
//  Weather-App
//
//  Created by Abdallah Eid on 1/15/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

/*
 This class contains the constants to be used in the project to reduce using hard coded
 values in the project.
 */

import Foundation

class Constants {
    static let APPID = "50e4573975f2239e269aace87dc3e0b0"
    static let BASEURL = "http://api.openweathermap.org/data/2.5"
    
    struct images {
        struct day {
            static let smallSize = [
                "clear sky" : "60x60 Clear Sky (Day)",
                "clouds" : "60x60 Few Clouds (Day)",
                "few clouds" : "60x60 Few Clouds (Day)",
                "scattered clouds" : "60x60 Scattered Clouds (Day)",
                "broken clouds" : "60x60 Broken Clouds (Day)",
                "shower rain" : "60x60 Shower Rain (Day)",
                "rain" : "60x60 Rain (Day)",
                "thunderstorm" : "60x60 Thunderstorm (Day)",
                "snow" : "60x60 Snow (Day)",
                "mist" : "60x60 Mist (Day)",
                "haze" : "60x60 Mist (Day)",

            ]
            static let bigSize = [
                "clear sky" : "100x100 Clear Sky (Day)",
                "clouds" : "100x100 Few Clouds (Day)",
                "few clouds" : "100x100 Few Clouds (Day)",
                "scattered clouds" : "100x100 Scattered Clouds (Day)",
                "broken clouds" : "100x100 Broken Clouds (Day)",
                "shower rain" : "100x100 Shower Rain (Day)",
                "rain" : "100x100 Rain (Day)",
                "thunderstorm" : "100x100 Thunderstorm (Day)",
                "snow" : "100x100 Snow (Day)",
                "mist" : "100x100 Mist (Day)",
                "haze" : "100x100 Mist (Day)",
            ]
        }
        struct night {
            static let smallSize = [
                "clear sky" : "60x60 Clear Sky (Night)",
                "clouds" : "60x60 Few Clouds (Night)",
                "few clouds" : "60x60 Few Clouds (Night)",
                "scattered clouds" : "60x60 Scattered Clouds (Night)",
                "broken clouds" : "60x60 Broken Clouds (Night)",
                "shower rain" : "60x60 Shower Rain (Night)",
                "rain" : "60x60 Rain (Night)",
                "thunderstorm" : "60x60 Thunderstorm (Night)",
                "snow" : "60x60 Snow (Night)",
                "mist" : "60x60 Mist (Night)",
                "haze" : "60x60 Mist (Night)",
            ]
            static let bigSize = [
                "clear sky" : "100x100 Clear Sky (Night)",
                "clouds" : "100x100 Few Clouds (Night)",
                "few clouds" : "100x100 Few Clouds (Night)",
                "scattered clouds" : "100x100 Scattered Clouds (Night)",
                "broken clouds" : "100x100 Broken Clouds (Night)",
                "shower rain" : "100x100 Shower Rain (Night)",
                "rain" : "100x100 Rain (Night)",
                "thunderstorm" : "100x100 Thunderstorm (Night)",
                "snow" : "100x100 Snow (Night)",
                "mist" : "100x100 Mist (Night)",
                "haze" : "100x100 Mist (Night)",

            ]
        }
    }
    
}

