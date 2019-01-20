//
//  ForecastViewController.swift
//  Weather-App
//
//  Created by Abdallah Eid on 1/16/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    // MARK: ------------ Outlets & Variables --------
    
    @IBOutlet var table: UITableView!
    
    var weathers:[Weather] = []
    var weathersForTable:[[Weather]] = []
    
    // MARK: ------------- viewDidLoad & viewDidAppear & ... ----------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        getForecast(cityName: city)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = city
    }
    
    // MARK: ------------ Actions & Functions --------
    
    func configureTable(){
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "tableCell")
    }
    
    func getForecast(cityName:String){
        /// TODO: Activity Indicator
        WeatherServices.sharedInstance().getForecast(cityName: cityName, completionHandlerForGetForecast: { (success, data, error) in
            guard success else{
                print ("There is an error: \(error!))")
                /// Stop Activity Indicator
                /// Make an alert
                return
            }
            
            if data != nil{
                self.weathers = data!
                DispatchQueue.main.async {
                    self.makeWeathersForTable()
                }
            }
            /// Stop Activity Indicator
        })
    }
    
    func makeWeathersForTable(){
        var cnt = 0
        var numberOfSections = 0
        if let thisHourWeather = weathers.first?.dt_txt! {
            if changeDisplayOfDate(dateFromAPI: thisHourWeather) != "00:00" {
                numberOfSections = 6
            } else {
                numberOfSections = 5
            }
        }
        while (cnt < numberOfSections) {
            let day = Calendar.current.date(byAdding: .day, value: cnt, to: Date())
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let stringDateFormatedLikeDateFromAPI = dateFormatter.string(from: day!)
            
            let weatherAccordingToADay = weathers.filter {
                let stringDateFromAPI = String($0.dt_txt!.prefix(10))
                print("here", stringDateFromAPI)
                return stringDateFormatedLikeDateFromAPI == stringDateFromAPI
            }
            weathersForTable.append(weatherAccordingToADay)
            cnt += 1
        }
        print(weathersForTable.count, "lalala")
        table.reloadData()
    }
    
    func changeDisplayOfDate(dateFromAPI: String) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateFromAPI)!
        
        dateFormatter.dateFormat = "HH:mm"
        return  dateFormatter.string(from: date)
    }
}

// MARK:------------ Delegates & Data Sources ------------

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weathersForTable.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathersForTable[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableCell
        
        cell.selectionStyle = .none
        cell.temperature.text = "\(Int((weathersForTable[indexPath.section][indexPath.row].main?.temp)! - 273.15))°"
        cell.weather.text = weathersForTable[indexPath.section][indexPath.row].weather?.first?.description
        cell.hour.text = changeDisplayOfDate(dateFromAPI: weathersForTable[indexPath.section][indexPath.row].dt_txt!)
        
        if weathersForTable[indexPath.section][indexPath.row].sys?.pod == "d" {
            // day
            if let imagePath = Constants.images.day.smallSize[(weathersForTable[indexPath.section][indexPath.row].weather?.first?.description)!] {
                cell.cellImageView.image  = UIImage(named: imagePath)
            } else {
                
                cell.cellImageView.image  = UIImage(named: Constants.images.day.smallSize[(weathersForTable[indexPath.section][indexPath.row].weather?.first?.main)!.lowercased()]!)
            }
        }
        else {
            // night
            if let imagePath = Constants.images.night.smallSize[(weathersForTable[indexPath.section][indexPath.row].weather?.first?.description)!] {
                cell.cellImageView.image  = UIImage(named: imagePath)
            } else {
                
                cell.cellImageView.image  = UIImage(named: Constants.images.night.smallSize[(weathersForTable[indexPath.section][indexPath.row].weather?.first?.main)!.lowercased()]!)
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section == 0 {
            return "Today"
        }
        
        let nextDay = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: nextDay!)

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        view.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        view.layer.borderWidth = 1
    }
    
    
}
