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
        
        celciusBtn.enabled = false
        celciusBtn.alpha = 0.3
        
    }
    
    func setupSwipe() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "dismissView")
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        
        view.addGestureRecognizer(swipeRight)
    }
    
    func fetchDetails(id: Int) {
        
        detailCity.detailWeather(id) { () -> () in
            
            dispatch_async(dispatch_get_main_queue()) {
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
        let frame = CGRectMake(0, 0, iconContainerView.frame.width, iconContainerView.frame.height)
        urlViewer.frame = frame
        
    }
    
    func showIcon() {
        
        let url = "\(BASE_URL_ICON)\(self.detailCity.icon).png"
        let nsUrl = NSURL(string: url)!
        let requestForIcon = NSURLRequest(URL: nsUrl)
        self.urlViewer.loadRequest(requestForIcon)
    }
    
    func dismissView() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func tempBtnPressed(sender: UIButton) {
        
        let newTemp = detailCity.changeMetricInch(sender.tag)
        
        if sender.tag == 0 {
            farenheitBtn.enabled = false
            farenheitBtn.alpha = 0.3
            tempLbl.text = newTemp
            celciusBtn.enabled = true
            celciusBtn.alpha = 1.0
            
        }
        else if sender.tag == 1 {
            celciusBtn.enabled = false
            celciusBtn.alpha = 0.3
            tempLbl.text = newTemp
            farenheitBtn.enabled = true
            farenheitBtn.alpha = 1.0
        }
        
    }
}
