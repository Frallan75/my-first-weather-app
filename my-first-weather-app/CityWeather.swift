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
    
    fileprivate var _cityName: String!
    fileprivate var _country: String!
    fileprivate var _lon: String!
    fileprivate var _lat: String!
    fileprivate var _desc: String!
    fileprivate var _icon: String!
    fileprivate var _temp: Double!
    fileprivate var _press: Double!
    fileprivate var _humidity: Int!
    fileprivate var _clouds: Int!
    fileprivate var _sunrise: String!
    fileprivate var _sunset: String!
    fileprivate var _error: Bool!
    
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
    
    func searchCity(_ citySearchString: String, completion: @escaping () -> ()) {
        
        self._error = false
        
        let session = URLSession.shared
        
        let rawUrl = "\(BASE_URL_FIND)\(citySearchString)\(URL_TEST_APPID)"
        
        let url = rawUrl.folding(options: .diacriticInsensitive, locale: Locale.current)
        
        let readyForNSURL = url.replacingOccurrences(of: " ", with: "")
        
        print(readyForNSURL)
        
        let nsUrl = URL(string: readyForNSURL)!
        
        let request = URLRequest(url: nsUrl)
        
        session.dataTask(with: request as URLRequest) {
            data, response, error in
            
        if let result = data {
            
                do {
                    let json = try JSONSerialization.jsonObject(with: result, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    if let dict = json as? Dictionary<String, AnyObject> {
                        
                        print("in json")
                        
                        if let count = dict["count"] as? Int, count > 0 {
                            print("detta är count \(count)")
                            
                            if let list = dict["list"] as? [Dictionary<String, AnyObject>], list.count > 0 {
                                
                                print("in list")
                                print(list.count)
                                
                                for x in 0 ..< list.count {
                                    
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
        } .resume()
    }
    
    func detailWeather(_ id: Int, completion: @escaping () -> ()) {
        print("in detail request")
        let session = URLSession.shared
        
        let url = "\(BASE_URL_ID)\(id)\(FINISH_URL_ID)"
        print(url)
        let nsUrl = URL(string: url)!
        
        let request = URLRequest(url: nsUrl)
        
        session.dataTask(with: request, completionHandler: {
            
            data, response, error in
            
            if let results = data {
                print("in detail results")
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: results, options: JSONSerialization.ReadingOptions.allowFragments)
                    
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
        }) .resume()
    }
    
    func unixTimeConvertion(_ unixTime: Double) -> String {
        
        let time = Date(timeIntervalSince1970: unixTime)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: time)
    }
    
    func changeMetricInch(_ sender: Int) -> String {
        
        var stringTempToReturn = ""
        
        if sender == 0 {
            
            stringTempToReturn = "\(String(format: "%.0f", self._temp * (9.0/5.0) + 32.0))˚F"
        }
        else if sender == 1 {
            
            stringTempToReturn = "\(String(format: "%.1f", self._temp))˚C"        }
        
        return stringTempToReturn
    }
}

