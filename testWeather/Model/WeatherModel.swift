//
//  WeatherModel.swift
//  testWeather
//
//  Created by Алексей Моторин on 16.05.2022.
//

import Foundation

struct WeatherModel {
    var conditionId: Int
    var cityName: String
    var temperature: Double
    var feelsLike: Double
    var weatherDescription: String
    var sunrise: Int
    var sunset: Int
    var timezone: Int

    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var feelsLikeString: String {
        return String(format: "%.1f", feelsLike)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...521:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 801...804:
            return "cloud"
        default:
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            
            if hour >= 18 || hour <= 4 {
                return "moon.stars"
            } else  {
                return "sun.max"
            }
        }
    }
    
    var sunriseString: String {
        dateFormater(date: sunrise)
    }
    
    var sunsetString: String {
        dateFormater(date: sunset)
    }
    
    private func dateFormater(date: Int) -> String {
        let date = NSDate(timeIntervalSince1970: Double(date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date as Date)
    }
    
}
