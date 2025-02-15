//
//  File.swift
//  Clima
//
//  Created by Ярослав Быстрицкий on 26.07.2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager , weather : WeatherModel)
    func didFailWithError(error:Error)
}


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?lat=57&lon=-2.15&appid=a07659fcdc7f4bb1ff7ea23a34bfb637&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let apiKey = "a07659fcdc7f4bb1ff7ea23a34bfb637"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=metric&appid=\(apiKey)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude : CLLocationDegrees , longitude : CLLocationDegrees) {
        let URLString = ("\(weatherURL)&lat=\(latitude)&lon=\(longitude)")
        performRequest(urlString: URLString)
    }
    
    func performRequest(urlString : String) {
        
        if  let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default )
            
            
            let task =  session.dataTask(with:  url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData : Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
       let decodedData =  try  decoder.decode(WeatherData.self, from: weatherData)
           let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temp: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
