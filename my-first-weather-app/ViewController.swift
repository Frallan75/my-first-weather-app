//
//  ViewController.swift
//  my-first-weather-app
//
//  Created by Francisco Claret on 09/03/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var city: CityWeather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        city = CityWeather(name: "helo", country: "opps")
        print(city.cityName)
    }
        
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    @IBAction func nssessionCallwThreadControl(sender: AnyObject) {
        print("in buton")
        
        city.searchCity("Lond") { () -> () in
            
            print("in closure")
            
            dispatch_async(dispatch_get_main_queue()) {
                print("in dispatch")
                print(self.city.cityName)
                self.outputLbl.text = self.city.cityName
            }
        }
    }
}


