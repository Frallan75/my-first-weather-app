//
//  DetailCityWeatherVC.swift
//  my-first-weather-app
//
//  Created by Francisco Claret on 10/03/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import WebKit


class DetailCityWeatherVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var pressLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    //    @IBOutlet weak var cloudsLbl: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var farenheitBtn: UIButton!
    @IBOutlet weak var celciusBtn: UIButton!
    
    
    var detailCity = CityWeather()
    var urlViewer = WKWebView()
    var id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSwipe()
        setupWKWebViewer()
        fetchDetails(id)
        
        celciusBtn.isEnabled = false
        celciusBtn.alpha = 0.3
        
    }
    
    func setupSwipe() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(DetailCityWeatherVC.dismissView))
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
        view.addGestureRecognizer(swipeRight)
    }
    
    func fetchDetails(_ id: Int) {
        
        detailCity.detailWeather(id) { () -> () in
            
            DispatchQueue.main.async {
                self.cityNameLbl.text = self.detailCity.cityName
                self.countryLbl.text = self.detailCity.country
                self.descLbl.text = self.detailCity.desc
                self.tempLbl.text = "\(String(format: "%.1f", self.detailCity.temp))˚C"
                self.pressLbl.text = "\(self.detailCity.press) pscal"
                self.humidityLbl.text = "\(self.detailCity.humidity) %"
                self.sunriseLbl.text = "\(self.detailCity.sunrise)"
                self.sunsetLbl.text = "\(self.detailCity.sunset)"
                
                self.showIcon()
            }
        }
    }
    
    func setupWKWebViewer() {
        
        iconContainerView.addSubview(urlViewer)
        let frame = CGRect(x: 0, y: 0, width: iconContainerView.frame.width, height: iconContainerView.frame.height)
        urlViewer.frame = frame
        
    }
    
    func showIcon() {
        
        let url = "\(BASE_URL_ICON)\(self.detailCity.icon).png"
        let nsUrl = URL(string: url)!
        let requestForIcon = URLRequest(url: nsUrl)
        self.urlViewer.load(requestForIcon)
    }
    
    func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tempBtnPressed(_ sender: UIButton) {
        
        let newTemp = detailCity.changeMetricInch(sender.tag)
        
        if sender.tag == 0 {
            farenheitBtn.isEnabled = false
            farenheitBtn.alpha = 0.3
            tempLbl.text = newTemp
            celciusBtn.isEnabled = true
            celciusBtn.alpha = 1.0
            
        }
        else if sender.tag == 1 {
            celciusBtn.isEnabled = false
            celciusBtn.alpha = 0.3
            tempLbl.text = newTemp
            farenheitBtn.isEnabled = true
            farenheitBtn.alpha = 1.0
        }
        
    }
}
