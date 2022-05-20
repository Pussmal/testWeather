//
//  WeatherData.swift
//  testWeather
//
//  Created by Алексей Моторин on 17.05.2022.
//

import Foundation

struct WeatherData: Codable {
    let coord: Coord
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: Sys
    let timezone: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let temp, feelsLike: Double
 
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
    
}

struct Weather: Codable {
    let id: Int
       let weatherDescription: String

       enum CodingKeys: String, CodingKey {
           case id
           case weatherDescription = "description"
       }
}

struct Sys: Codable {
    let sunrise, sunset: Int
}
