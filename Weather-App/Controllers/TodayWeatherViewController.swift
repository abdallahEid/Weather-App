//
//  TodayWeatherViewController.swift
//  Weather-App
//
//  Created by Abdallah Eid on 1/16/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase
import CodableFirebase

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
    var isFunctionCalled = false
    var ref:DatabaseReference!

    // MARK: ------------- viewDidLoad & viewDidAppear & ... ----------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUserLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Today"
        ref = Database.database().reference()
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
                
                let firebaseData = try! FirebaseEncoder().encode(weather)
                
                if let uuid = UserDefaults.standard.object(forKey: "uuid") as? String{
                    self.ref.child("users").child(uuid).child("weather").setValue(firebaseData)
                }
                else {
                    let uuid = UUID().uuidString
                    self.ref.child("users").child(uuid).child("weather").setValue(firebaseData)
                    UserDefaults.standard.set(uuid , forKey: "uuid")
                }
            
                
                DispatchQueue.main.async {
                    let sunrise = Date(timeIntervalSince1970: (weather.sys?.sunrise)!)
                    let sunset = Date(timeIntervalSince1970: (weather.sys?.sunset)!)
                    
                    if Date() > sunrise && Date() < sunset{
                        // day
                        if let imagePath = Constants.images.day.bigSize[(weather.weather?.first?.description)!] {
                            self.statusIcon.image = UIImage(named: imagePath)
                        } else {
                            for (key, value) in Constants.images.day.bigSize {
                                if (weather.weather?.first?.description)!.contains(key) {
                                    self.statusIcon.image = UIImage(named: value)
                                }
                            }
                        }
                    }
                    else {
                        // night
                        if let imagePath = Constants.images.night.bigSize[(weather.weather?.first?.description)!] {
                            self.statusIcon.image = UIImage(named: imagePath)
                        } else {
                            for (key, value) in Constants.images.night.bigSize {
                                if (weather.weather?.first?.description)!.contains(key) {
                                    self.statusIcon.image = UIImage(named: value)
                                }
                            }
                        }
                    }
                    
                    self.temperatureAndStatus.text = "\(Int((weather.main?.temp)! - 273.15))°C | \((weather.weather?.first?.main)!)"
                    
                    self.humidity.text = String(format: "%g",(weather.main?.humidity)!) + "%"
                    self.pressure.text = String(format: "%g",(weather.main?.pressure)!) + " hPa"
                    if let rain = weather.rain {
                        self.precipitation.text = String(format: "%g",(rain.h3)!) + " mm"
                    }
                    self.windSpeed.text = String(format: "%g",(weather.wind?.speed)!) + " km / h"
                    
                    let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
                    if let degree = weather.wind?.deg {
                        let i = Int((degree + 11.25)/22.5)
                        self.windDirection.text = String(describing: directions[i % 16])
                    } else {
                        self.windDirection.text = " "
                    }
                    

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
        var currentLocation = [
            "country": "",
            "city": "",
            "longitude": "\(location.longitude)",
            "latitude": "\(location.latitude)"
        ]
        geoCoder.reverseGeocodeLocation(geoLocation, completionHandler: {
                placemarks, error -> Void in
            if let placemarks = placemarks {
                guard let placeMark = placemarks.first else { return }
                
                if placeMark.subAdministrativeArea != nil {
                    city = placeMark.subAdministrativeArea!
                }
                else {
                    if placeMark.administrativeArea != nil {
                        city = placeMark.administrativeArea!
                    }
                }
                
                currentLocation["city"] = city
                
                if !self.isFunctionCalled {
                    self.getTodayWeather(cityName: city)
                    self.isFunctionCalled = true
                }
                self.countryAndCity.text = city
                
                if let country = placeMark.country {
                    currentLocation["country"] = country
                    self.countryAndCity.text = self.countryAndCity.text! + ", " + country
                }
                
                let firebaseData = try! FirebaseEncoder().encode(currentLocation)
                
                if let uuid = UserDefaults.standard.object(forKey: "uuid") as? String{
                    self.ref.child("users").child(uuid).child("location").setValue(firebaseData)
                }
                else {
                    let uuid = UUID().uuidString
                    self.ref.child("users").child(uuid).child("location").setValue(firebaseData)
                    UserDefaults.standard.set(uuid , forKey: "uuid")
                }
            }

        })
    }
}
