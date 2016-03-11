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
    
    var city = CityWeather()
    var numberOfRows: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + view.frame.size.height, view.frame.size.width, view.frame.height * 0.8)
        view.addSubview(tableView)
        
        searchTxtFeild.delegate = self
        searchTxtFeild.returnKeyType = UIReturnKeyType.Go
        searchTxtFeild.autocorrectionType = .No
        searchTxtFeild.keyboardType = .ASCIICapable
       
    }
    
    @IBAction func dismissViewBtnPressed(sender: UIButton) {
        
        dismissView()
    }
    
    func fetchSearch() {
        
        city.searchArrayCity = []
        city.searchArrayCountry = []
        city.searchArrayId = []
        
        tableView.reloadData()
        
        if searchTxtFeild.isFirstResponder() && searchTxtFeild.text != nil && searchTxtFeild.text != "" {
            
            city.searchCity(searchTxtFeild.text!) { () -> () in
                print(self.city.sunrise)
                
                if !self.city.error {
                    
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
        
        self.searchTxtFeild.text = ""
        
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
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//        if section == 0 {
//            
//            return 35.0
//        }
//    return 0.0
//    }
//    
////    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////       
////        if section == 0 {
////            
////            let myHeaderView = UIButton()
////            myHeaderView.sizeToFit()
////            myHeaderView.backgroundColor = UIColor(patternImage: UIImage(named: "AD.png")!)
////            return myHeaderView
////            
////        }
////        
////        return UIView()
////    }
}

//UITEXTFIELD
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        fetchSearch()
        self.view.endEditing(true)
        
        return false
    }
}

