//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManger.delegate = self
        
        locationManger.requestWhenInUseAuthorization()
        locationManger.requestLocation()
        // Do any additional setup after loading the view.
    }
    @IBAction func locationPressed(_ sender: Any) {
        locationManger.requestLocation()
    }
}

// MARK: - UITextFieldDelegate
extension WeatherViewController : UITextViewDelegate {
    
    @IBAction func searchPassed(_ sender: Any) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }
        else{
            textField.placeholder = "Type Something"
            return false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let cityName = searchTextField.text {
            weatherManager.fetchWeatherURL(cityName: cityName)
        }
       
        searchTextField.text = ""
        
    }
    
}
extension WeatherViewController : weatherProtocol {
    
     func didUpdatedWeather(_ weatherManager: WeatherManager , weather : weatherModel) {
         print("VC = ",weather.temperature)
         DispatchQueue.main.async {
             self.temperatureLabel.text = weather.temperatureString
             self.conditionImageView.image = UIImage(systemName: weather.weatherString)
             self.cityLabel.text = weather.cityName
         }
        
     }
     
     func didFailWithError(error: Error) {
         print(error)
     }
}

extension WeatherViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManger.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeatherURL(latitude:lat,longitude :lon)
        
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
