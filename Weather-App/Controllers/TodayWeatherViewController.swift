//
//  TodayWeatherViewController.swift
//  Weather-App
//
//  Created by Abdallah Eid on 1/16/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

import UIKit
import CoreLocation

var city:String!

class TodayWeatherViewController: UIViewController {

    // MARK: ------------ Outlets & Variables --------

    @IBOutlet var windDirection: UILabel!
    @IBOutlet var windSpeed: UILabel!
    @IBOutlet var pressure: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var precipitation: UILabel!
    @IBOutlet var temperatureAndStatus: UILabel!
    @IBOutlet var statusIcon: UIImageView!
    @IBOutlet var countryAndCity: UILabel!
    
    let locationManager = CLLocationManager()

    // MARK: ------------- viewDidLoad & viewDidAppear & ... ----------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Today"
    }

    // MARK: ------------ Actions & Functions --------

    func configureUserLocation(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func getTodayWeather(cityName:String){
        /// TODO: Activity Indicator
        WeatherServices.sharedInstance().getTodayWeather(cityName: cityName, completionHandlerForGetTodayWeather: { (success, data, error) in
            guard success else{
                print ("There is an error: \(error!))")
                /// Stop Activity Indicator
                /// Make an alert
                return
            }
            
            if let weather = data{
                DispatchQueue.main.async {
                    self.temperatureAndStatus.text = String(describing: (weather.main?.temp)!) + "°C | " + (weather.weather?.first?.main)!
                    
                    self.humidity.text = String(format: "%g",(weather.main?.humidity)!) + "%"
                    self.pressure.text = String(format: "%g",(weather.main?.pressure)!) + " hPa"
                    if let rain = weather.rain {
                        self.precipitation.text = String(format: "%g",(rain.h3)!) + " mm"
                    }
                    self.windSpeed.text = String(format: "%g",(weather.wind?.speed)!) + " km / h"
                    
                    let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
                    let i: Int = Int(((weather.wind?.deg)! + 11.25)/22.5)
                    
                    self.windDirection.text = String(describing: directions[i % 16])

                }
            }
            /// Stop Activity Indicator
        })
        
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        let textToShare = [countryAndCity.text! + ", " + temperatureAndStatus.text! ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // for iPads
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

// MARK:------------ Delegates & Data Sources ------------

extension TodayWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let location = CLLocationCoordinate2DMake(userLocation!.coordinate.latitude, userLocation!.coordinate.longitude)
        print("locations = \(location.latitude) \(location.longitude)")
        
        let geoCoder = CLGeocoder()
        let geoLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geoCoder.reverseGeocodeLocation(geoLocation, completionHandler: {
                placemarks, error -> Void in
            guard let placeMark = placemarks!.first else { return }
            
            if placeMark.subAdministrativeArea != nil {
                city = placeMark.subAdministrativeArea!
            }
            else {
                if placeMark.administrativeArea != nil {
                    city = placeMark.administrativeArea!
                }
            }
            
            self.getTodayWeather(cityName: city)
            self.countryAndCity.text = city
            
            if let country = placeMark.country {
                print(country)
                self.countryAndCity.text = self.countryAndCity.text! + ", " + country
            }

        })
    }
}
