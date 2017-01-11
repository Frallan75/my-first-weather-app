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
        
        navigationController?.isNavigationBarHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + view.frame.size.height, width: view.frame.size.width, height: view.frame.height * 0.8)
        view.addSubview(tableView)
        
        searchTxtFeild.delegate = self
        searchTxtFeild.returnKeyType = UIReturnKeyType.go
        searchTxtFeild.autocorrectionType = .no
        searchTxtFeild.keyboardType = .asciiCapable
       
    }
    
    @IBAction func dismissViewBtnPressed(_ sender: UIButton) {
        
        dismissView()
    }
    
    func fetchSearch() {
        
        city.searchArrayCity = []
        city.searchArrayCountry = []
        city.searchArrayId = []
        
        tableView.reloadData()
        
        if searchTxtFeild.isFirstResponder && searchTxtFeild.text != nil && searchTxtFeild.text != "" {
            
            city.searchCity(searchTxtFeild.text!) { () -> () in
                print(self.city.sunrise)
                
                if !self.city.error {
                    
                    DispatchQueue.main.async {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC" {
            
            if let vc = segue.destination as? DetailCityWeatherVC {
                vc.id = sender as? Int
            }
        }
    }
    
    func showView() {
        
        let viewToShow = self.tableView
        
        UIView.animate(withDuration: 0.6, animations: {
            viewToShow?.frame = CGRect(x: (viewToShow?.frame.origin.x)!, y: (viewToShow?.frame.origin.y)! - (viewToShow?.frame.height)!, width: (viewToShow?.frame.size.width)!, height: (viewToShow?.frame.size.height)!)
        }) 
    }
    
    func dismissView() {

        let viewToDismiss = self.tableView
        
        self.searchTxtFeild.text = ""
        
        UIView.animate(withDuration: 0.6, animations: {
            viewToDismiss?.frame = CGRect(x: (viewToDismiss?.frame.origin.x)!, y: (viewToDismiss?.frame.origin.y)! + (viewToDismiss?.frame.height)!, width: (viewToDismiss?.frame.size.width)!, height: (viewToDismiss?.frame.size.height)!)
        }) 
    }
    
    func presentAlert() {
        
        let myAlert = UIAlertController(title: "Ooooops!", message: "The server coudn't find your city, please try again!", preferredStyle: UIAlertControllerStyle.alert)
        
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        present(myAlert, animated: true) { () -> Void in
            self.searchTxtFeild.text = ""
        }
    }
}

//TABLEVIEW
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return city.searchArrayCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as? CityCell {
            
            print("\(city.searchArrayCity[indexPath.row])")
            cell.titleLbl.text = city.searchArrayCity[indexPath.row]
            cell.countryLbl.text = city.searchArrayCountry[indexPath.row]
            return cell
        }
        return CityCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let id = city.searchArrayId[indexPath.row]
        print(id)
        performSegue(withIdentifier: "detailVC", sender: id)
    }
}

//UITEXTFIELD
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        fetchSearch()
        self.view.endEditing(true)
        
        return false
    }
}

