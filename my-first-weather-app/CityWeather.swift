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
    
    var searchArray: [String] = []
    
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

    init(name: String, country: String) {
        self._cityName = name
        self._country = country
    }
    
    func searchCity(citySearchString: String, completion: () -> ()) {
        
        print("in search city")
        
        let session = NSURLSession.sharedSession()
        
        let url = "http://api.openweathermap.org/data/2.5/find?q=London&type=like&appid=44db6a862fba0b067b1930da0d769e98"
        
        let nsUrl = NSURL(string: url)
        
        let request = NSURLRequest(URL: nsUrl!)
        
        session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            print(data)
            print(response)
            
            if let result = data {
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(result, options: NSJSONReadingOptions.AllowFragments)
                    
                    if let dict = json as? Dictionary<String, AnyObject> {
                        
                        print("in json")
                    
                        if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                           
                            print("in list")
                            
                            if let cityName = list[1]["name"] as? String {
                                
                                print("in cityName")
                                
                                self._cityName = cityName
                                
                                completion()
                            }
                        }
                    }
                    
                } catch let err as NSError {
                    print(err.debugDescription)
                }
            }
        }.resume()
    }

}
