//
//  CityWeather.swift
//  my-first-weather-app
//
//  Created by Francisco Claret on 09/03/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import Foundation
import Alamofire

class CityWeather {
    
    private var _cityName: String!
    private var _country: String!
    private var _lon: String!
    private var _lat: String!
    private var _desc: String!
    private var _icon: String!
    private var _temp: Double!
    private var _press: Double!
    private var _humidity: Int!
    private var _clouds: Int!
    private var _sunrise: String!
    private var _sunset: String!
    private var _error: Bool!

    var searchArrayCity: [String] = [""]
    var searchArrayCountry: [String] = [""]
    var searchArrayId: [Int] = []
    
    var cityName: String {
        if _cityName == nil {
            _cityName = "N/A"
        }
        return _cityName
    }
    
    var country: String {
        if _country == nil {
            _country = "N/A"
        }
        return _country
    }
    
    var lon: String {
        if _lon == nil {
            _lon = "N/A"
        }
        return _lon
    }
    
    var lat: String {
        if _lat == nil {
            _lat = "N/A"
        }
        return _lat
    }
    
    var desc: String {
        if _desc == nil {
            _desc = ""
        }
        return _desc
    }
    
    var icon: String {
        if _icon == nil {
            _icon = ""
        }
        return _icon
    }
    
    var temp: Double {
        if _temp == nil {
            _temp = 0.0
        }
        return _temp
    }
    
    var press: Double {
        if _press == nil {
            _press = 0.0
        }
        return _press
    }
    
    var humidity: Int {
        if _humidity == nil {
            _humidity = 0
        }
        return _humidity
    }
    
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    
    var sunset: String {
        if _sunset == nil {
            _sunset = ""
        }
        return _sunset
    }
    
    var error: Bool {
        return _error
    }
    
    func searchCity(citySearchString: String, completion: () -> ()) {
        
        self._error = false
        
        let session = NSURLSession.sharedSession()
        
        let rawUrl = "\(BASE_URL_FIND)\(citySearchString)\(URL_TEST_APPID)"
    
        let url = rawUrl.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
        
        let readyForNSURL = url.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        print(readyForNSURL)
        
        let nsUrl = NSURL(string: readyForNSURL)!
        
        let request = NSURLRequest(URL: nsUrl)
        
        session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if let result = data {
            
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(result, options: NSJSONReadingOptions.AllowFragments)
                    
                    if let dict = json as? Dictionary<String, AnyObject> {
                        
                        print("in json")
                        
                        if let count = dict["count"] as? Int where count > 0 {
                            print("detta är count \(count)")
                            
                            if let list = dict["list"] as? [Dictionary<String, AnyObject>] where list.count > 0 {
                                
                                print("in list")
                                print(list.count)
                                
                                for var x = 0; x < list.count; x++ {
                                    
                                    if let cityName = list[x]["name"] as? String {
                                        
                                        self.searchArrayCity.append(cityName)
                                    }
                                    
                                    if let id = list[x]["id"] as? Int {
                                        
                                        self.searchArrayId.append(id)
                                    }
                                    
                                    if let sys = list[x]["sys"] as? Dictionary<String, AnyObject> {
                                        
                                        if let country = sys["country"] as? String {
                                            
                                            self.searchArrayCountry.append(country)
                                        }
                                    }
                                }
                            }
                          
                        }
                        else {
                            print("in else hansli")
                            self._error = true
                        }
                    }
                      completion()
                } catch {
                     self._error = true
                }
                
            }
            }.resume()
    }
    
    func detailWeather(id: Int, completion: () -> ()) {
        print("in detail request")
        let session = NSURLSession.sharedSession()
        
        let url = "\(BASE_URL_ID)\(id)\(FINISH_URL_ID)"
        print(url)
        let nsUrl = NSURL(string: url)!
        
        let request = NSURLRequest(URL: nsUrl)
        
        session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if let results = data {
                print("in detail results")
                do {
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(results, options: NSJSONReadingOptions.AllowFragments)
                    
                    print("in json try")
                    
                    if let dict = json as? Dictionary<String, AnyObject> {
                        
                        print("in dict")
                        
                        if let name = dict["name"] as? String {
                            self._cityName = name
                            print(name)
                        }
                        
                        if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                            
                            print("in weather")
                            
                            if let desc = weather[0]["description"] as? String {
                                self._desc = desc
                                print(desc)
                            }
                            
                            if let icon = weather[0]["icon"] as? String {
                                self._icon = icon
                                print(icon)
                            }
                        }
                        
                        if let main = dict["main"] as? Dictionary<String, AnyObject> {
                            print("in main")
                            if let temp = main["temp"] as? Double {
                                self._temp = temp
                                print(temp)
                            }
                            
                            if let press = main["pressure"] as? Double {
                                self._press = press
                                print(press)
                            }
                            
                            if let humidity = main["humidity"] as? Int {
                                self._humidity = humidity
                                print(humidity)
                            }
                        }
                        
                        if let sys = dict["sys"] as? Dictionary<String, AnyObject> {
                            
                            if let country = sys["country"] as? String {
                                self._country = country
                            }
                            
                            if let sunrise = sys["sunrise"] as? Int {
                                
                                self._sunrise = self.unixTimeConvertion(Double(sunrise))
                            }
                            
                            if let sunset = sys["sunset"] as? Int {
                               
                                self._sunset = self.unixTimeConvertion(Double(sunset))
                            }
                        }
                        
                        completion()
                    }
                } catch let err as NSError {
                    print(err.debugDescription)
                }
            }
            }.resume()
    }
    
    func unixTimeConvertion(unixTime: Double) -> String {
        
        let time = NSDate(timeIntervalSince1970: unixTime)
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.stringFromDate(time)
    }
    
    func changeMetricInch(sender: Int) -> String {
    
        var stringTempToReturn = ""
        
        if sender == 0 {
            
            stringTempToReturn = "\(String(format: "%.0f", self._temp * (9.0/5.0) + 32.0))˚F"
        }
        else if sender == 1 {
            
            stringTempToReturn = "\(String(format: "%.1f", self._temp))˚C"        }
        
        return stringTempToReturn
    }
}

