//
//  WeatherData.swift
//  Clima
//
//  Created by Jorge Pinto on 8/28/23.
//

import Foundation

struct WeatherData: Decodable{
    let name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Decodable {
    let temp: Double
}
struct Weather: Decodable{
    let id: Int
    let description: String
}
