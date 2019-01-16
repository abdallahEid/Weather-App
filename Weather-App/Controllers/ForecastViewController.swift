//
//  ForecastViewController.swift
//  Weather-App
//
//  Created by Abdallah Eid on 1/16/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
    }
    
    func configureTable(){
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "tableCell")
    }
    
}

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableCell
        
        cell.hour.text = "14:00"
        cell.temperature.text = "22°"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Today"
        }
        return "Friday"

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        view.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        view.layer.borderWidth = 1
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.textColor = UIColor.black
    }
    
    
}
