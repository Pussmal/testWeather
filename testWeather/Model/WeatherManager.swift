//
//  WeatherManager.swift
//  testWeather
//
//  Created by Алексей Моторин on 17.05.2022.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdadeWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=97caa101d5f5458101e49eac156ac142&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWweather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString)
    }
    
    private func performRequest(_ urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdadeWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherDate: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherDate)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let feelsLike = decodedData.main.feelsLike
            let weatherDescription = decodedData.weather[0].weatherDescription
            let sunrise = decodedData.sys.sunrise
            let sunset = decodedData.sys.sunset
            let timezone = decodedData.timezone
            
            let weather = WeatherModel(conditionId: id,
                                       cityName: name,
                                       temperature: temp,
                                       feelsLike: feelsLike,
                                       weatherDescription: weatherDescription,
                                       sunrise: sunrise,
                                       sunset: sunset,
                                       timezone: timezone)
    
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
