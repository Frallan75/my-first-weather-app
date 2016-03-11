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
    @IBOutlet weak var searchTxtFeild: UITextField!
    @IBOutlet weak var newSearchButton: UIButton!
    @IBOutlet weak var goButton: UIButton!
    
    
    var city: CityWeather!
    var numberOfRows: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        searchTxtFeild.delegate = self

        city = CityWeather()
        
        tableView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + view.frame.size.height, view.frame.size.width, view.frame.height * 0.8)

        goButton.enabled = true
        goButton.layer.cornerRadius = 5
        goButton.layer.borderWidth = 1
        goButton.layer.borderColor = UIColor.grayColor().CGColor
        
        newSearchButton.hidden = true
        newSearchButton.layer.cornerRadius = 5
        newSearchButton.layer.borderWidth = 1
        newSearchButton.layer.borderColor = UIColor.grayColor().CGColor
        
        searchTxtFeild.returnKeyType = UIReturnKeyType.Go
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        goButton.enabled = false
//        newSearchButton.enabled = true
    }

    @IBAction func goButtonPressed(sender: UIButton) {
        
        fetchSearch()
    }
    
    @IBAction func newSearchButtonPressed(sender: UIButton) {
        
        dismissView()
        searchTxtFeild.text = ""
        switchButtonEnable()
    }
    
    
    func switchButtonEnable() {
        if goButton.enabled == true {
            goButton.enabled = false
            goButton.alpha = 0.3
            newSearchButton.hidden = false
        }
        else {
            goButton.enabled = true
            goButton.alpha = 1.0
            newSearchButton.hidden = true
        }
    }
    
    func fetchSearch() {
        
        city.searchArrayCity = []
        city.searchArrayCountry = []
        city.searchArrayId = []
        
        tableView.reloadData()

        
        if searchTxtFeild.isFirstResponder() && searchTxtFeild.text != nil && searchTxtFeild.text != "" {
            
            if let searchText = searchTxtFeild.text {
                city.searchCity(searchText) { () -> () in
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.numberOfRows = self.city.searchArrayCity.count
                        self.tableView.reloadData()
                    }
                }
            }
            showView()
            switchButtonEnable()
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailVC" {
            
            if let vc = segue.destinationViewController as? DetailCityWeatherVC {
                vc.id = sender as? Int
            }
        }
    }
    
    func showView() {
        
        let viewToShow = self.tableView
        
        UIView.animateWithDuration(0.6) {
            viewToShow.frame = CGRectMake(viewToShow.frame.origin.x, viewToShow.frame.origin.y - viewToShow.frame.height, viewToShow.frame.size.width, viewToShow.frame.size.height)
        }
        
    }
    
    func dismissView() {
        
        let viewToDismiss = self.tableView
        
        UIView.animateWithDuration(0.6) {
            viewToDismiss.frame = CGRectMake(viewToDismiss.frame.origin.x, viewToDismiss.frame.origin.y + viewToDismiss.frame.height, viewToDismiss.frame.size.width, viewToDismiss.frame.size.height)
        }

        
    }
}

//TABLEVIEW
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return city.searchArrayCity.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("CityCell") as? CityCell {
        
            print("\(city.searchArrayCity[indexPath.row])")
            cell.titleLbl.text = city.searchArrayCity[indexPath.row]
            cell.countryLbl.text = city.searchArrayCountry[indexPath.row]
            return cell
        }
    return CityCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let id = city.searchArrayId[indexPath.row]
        print(id)
        performSegueWithIdentifier("detailVC", sender: id)
    }
}

//UITEXTFIELD
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        fetchSearch()
        
        self.view.endEditing(true)
        
        return false
    }
    
    
}

