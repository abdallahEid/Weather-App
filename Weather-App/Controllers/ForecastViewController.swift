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
                    self.table.reloadData()
                }
            }
            /// Stop Activity Indicator
        })
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = Calendar.current.date(byAdding: .day, value: section, to: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDateFormatedLikeDateFromAPI = dateFormatter.string(from: day!)
        
        let weatherAccordingToADay = weathers.filter {
            let index = $0.dt_txt!.index(of: " ")!
            let stringDateFromAPI = String($0.dt_txt![..<index])
            return stringDateFormatedLikeDateFromAPI == stringDateFromAPI
        }
        
        return weatherAccordingToADay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableCell
        
        cell.hour.text = "14:00"
        cell.temperature.text = "\(Int((weathers[indexPath.row].main?.temp)! - 273.15))°"
        cell.weather.text = weathers[indexPath.row].weather?.first?.main
        
        cell.hour.text = changeDisplayOfDate(dateFromAPI: weathers[indexPath.row].dt_txt!)
        print(changeDisplayOfDate(dateFromAPI: (weathers.first?.dt_txt!)!))
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let thisHourWeather = weathers.first?.dt_txt! {
            if changeDisplayOfDate(dateFromAPI: thisHourWeather) != "00:00" {
                return 6
            }
            else {
                return 5
            }
        }
        return 0

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
