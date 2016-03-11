//
//  DetailCityWeatherVC.swift
//  my-first-weather-app
//
//  Created by Francisco Claret on 10/03/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit
import WebKit


class DetailCityWeatherVC: UIViewController {

    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
//    @IBOutlet weak var pressLbl: UILabe§  l!
//    @IBOutlet weak var humidityLbl: UILabel!
//    @IBOutlet weak var cloudsLbl: UILabel!
//    @IBOutlet weak var suriseLbl: UILabel!
//    @IBOutlet weak var sunsetLbl: UILabel!
    
    
    var detailCity = CityWeather()
    var urlViewer = WKWebView()
    
    var id: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWKWebViewer()
        fetchDetails(id)
     
    }
    
    func fetchDetails(id: Int) {
        
        detailCity.detailWeather(id) { () -> () in
            
            dispatch_async(dispatch_get_main_queue()) {
                self.cityNameLbl.text = self.detailCity.cityName
                self.countryLbl.text = self.detailCity.country
                self.descLbl.text = self.detailCity.desc
                self.tempLbl.text = "\(self.detailCity.temp) C"
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
}
