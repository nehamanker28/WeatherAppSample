//
//  weatherManager.swift
//  Clima
//
//  Created by neha manker on 11/05/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol weatherProtocol {
    func didUpdatedWeather(_ weatherManager: WeatherManager , weather : weatherModel)
    func didFailWithError(error : Error)
}

struct WeatherManager {
    var delegate : weatherProtocol!
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=61c8ca250b2c77384c9ce10b6f8333ad"
    
    func fetchWeatherURL(cityName : String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeatherURL(latitude: CLLocationDegrees,longitude : CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        //print(urlString)
        performRequest(with: urlString)
    }
    func performRequest(with urlString : String){
        //create URL
        if let url = URL(string: urlString){
            //Create URLSession
            let urlSession = URLSession(configuration: .default)
            //give a task to URLSession
            let task = urlSession.dataTask(with: url) { (data, respose, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseData(safeData) //sending data to decode
                    {
                        //protocol delegate method as it works as intern boss method here weatheManager is boss and weatherViewController is intern so we can use weather manager using this delegate method.
                        //1. we have created protocol first and declared the method name "getUpdateWeather" and by calling self.delegate?.getUpdatedWeather(weather: weather) we are getting datamodel which we needed
                        // 2.  then we have to declare del var delegate : weatherProtocol!
                        self.delegate?.didUpdatedWeather(self, weather: weather)

                    }
                }
            }
            //start the task
            task.resume()
        }
      
    }
    func parseData(_ weatherData : Data) -> weatherModel?  {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) //calling weather dataclass to decode the weatherData
            
            //getting all the data after decoding
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let cityName = decodedData.name
        // created a weather model so we can get encoded data and sending back to parse data as datamodel
            
            let weather = weatherModel(condtionId: id, cityName: cityName, temperature: temp)
           return weather
        } catch  {
            delegate.didFailWithError(error: error)
        }
        return nil
    }
    
 
}
