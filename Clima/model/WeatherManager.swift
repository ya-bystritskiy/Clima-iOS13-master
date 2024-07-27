//
//  File.swift
//  Clima
//
//  Created by Ярослав Быстрицкий on 26.07.2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?lat=57&lon=-2.15&appid=a07659fcdc7f4bb1ff7ea23a34bfb637&units=metric"
    
    func fetchWeather(cityName: String){
        let apiKey = "a07659fcdc7f4bb1ff7ea23a34bfb637"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=metric&appid=\(apiKey)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString : String) {
        
        if  let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default )
            
            
            let task =  session.dataTask(with:  url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                   parseJSON(weatherData: safeData)
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData : Data) {
        
    }
    
}
