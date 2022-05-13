//
//  weatherData.swift
//  Clima
//
//  Created by neha manker on 12/05/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
//codable = able to decode and encode

struct WeatherData : Codable {
    let name : String
    let main : main //its an array
    let weather : [Weather] // as weather is a dictionary
}

struct main : Codable{ // to code and decode
    let temp : Double
}

struct Weather : Codable {
    let id : Int
}
