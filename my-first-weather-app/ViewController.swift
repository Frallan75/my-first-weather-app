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
    
    var city = CityWeather()
    var numberOfRows: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        searchTxtFeild.delegate = self
        
        newSearchButton.hidden = true
        
        searchTxtFeild.returnKeyType = UIReturnKeyType.Go
        searchTxtFeild.autocorrectionType = .No
        searchTxtFeild.keyboardType = .ASCIICapable
        
        tableView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + view.frame.size.height, view.frame.size.width, view.frame.height * 0.8)

    }
    
    @IBAction func newSearchButtonPressed(sender: UIButton) {
        
        dismissView()
        searchTxtFeild.text = ""
        newSearchButtonSwitch()
    }
    
    func newSearchButtonSwitch() {
        print("in newButtin")
        if newSearchButton.hidden {
            print("in unhide")
            newSearchButton.hidden = false
        }
        newSearchButton.hidden = true
    }
    
    func fetchSearch() {
        
        city.searchArrayCity = []
        city.searchArrayCountry = []
        city.searchArrayId = []
        
        tableView.reloadData()

        if searchTxtFeild.isFirstResponder() && searchTxtFeild.text != nil && searchTxtFeild.text != "" {
            
            if let searchText = searchTxtFeild.text {
                
                let trimmedSearchText = searchText.stringByReplacingOccurrencesOfString(" ", withString: "")
                let removedInappropiateChar = trimmedSearchText.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
                
                print(removedInappropiateChar)
                
                city.searchCity(trimmedSearchText) { () -> () in
                    print(self.city.sunrise)
                    if self.city.sunrise != 0 {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            print("in dispatch row 1")
                            self.numberOfRows = self.city.searchArrayCity.count
                            print(self.city.searchArrayCity[0])
                            self.tableView.reloadData()
                            self.showView()
                        }
                    } else {
                        
                        self.presentAlert()
                    }
                    
                }
            }
           
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
        print("in show view")
        UIView.animateWithDuration(0.6) {
            viewToShow.frame = CGRectMake(viewToShow.frame.origin.x, viewToShow.frame.origin.y - viewToShow.frame.height, viewToShow.frame.size.width, viewToShow.frame.size.height)
        }
        
    }
    
    func dismissView() {
        print("in dismissview")
        let viewToDismiss = self.tableView
        
        UIView.animateWithDuration(0.6) {
            viewToDismiss.frame = CGRectMake(viewToDismiss.frame.origin.x, viewToDismiss.frame.origin.y + viewToDismiss.frame.height, viewToDismiss.frame.size.width, viewToDismiss.frame.size.height)
        }
    }
    
    func presentAlert() {
        
        let myAlert = UIAlertController(title: "Ooooops!", message: "The server coudn't find your city, please try again!", preferredStyle: UIAlertControllerStyle.Alert)
        
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(myAlert, animated: true) { () -> Void in
            self.searchTxtFeild.text = ""
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
        
        newSearchButton.hidden = false
        fetchSearch()
        self.view.endEditing(true)
        
        return false
    }
}

