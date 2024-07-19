//
//  WeatherManager.swift
//  Clima
//
//  Created by Jorge Pinto on 8/25/23.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let WeatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=5c8a5b9b49a69ddcb101fae6b0af893f&units=imperial"
    var delegate: WeatherManagerDelegate?
    func fetchWeather(_ cityName: String){
        let urlString = "\(WeatherURL)&q=\(cityName)"
        //print(urlString)
        performRequest(urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(WeatherURL)&lat=\(latitude)&lon=\(longitude)"
        //print(urlString)
        performRequest(urlString)
    }
    func performRequest(_ urlString: String){
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data:urlResponse:error:))
            task.resume()
        }
    }
    func handle(data: Data?, urlResponse: URLResponse?, error: Error?){
        
        if error != nil {
            self.delegate?.didFailWithError(error: error!)
            return
        }
        if let safeData = data{
            if let weather = parseJSON(weatherData: safeData){
                self.delegate?.didUpdateWeather(weather: weather)
                
            }
        }
        
    }
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            let temperature = decoderData.main.temp
            let cityName = decoderData.name
            let id = decoderData.weather[0].id
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temperature)
            return weather
            
            
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
