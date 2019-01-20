//
//  Weather.swift
//  Weather-App
//
//  Created by Abdallah Eid on 1/17/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

import Foundation

class Weather:Codable {
    let wind: Wind?
    let rain: Rain?
    let weather: [WeatherBasic]?
    let main: WeatherAttributes?
    let dt_txt:String? // date
    let sys: SunInformation?
}
