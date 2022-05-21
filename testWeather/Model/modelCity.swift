//
//  modelCity.swift
//  testWeather
//
//  Created by Алексей Моторин on 21.05.2022.
//

import RealmSwift

class WeatherCities: Object {
    @objc dynamic var nameCity: String = ""
    
    convenience init(name: String) {
        self.init()
        nameCity = name
    }
}
