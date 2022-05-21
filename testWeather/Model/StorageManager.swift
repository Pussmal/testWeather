//
//  StorageManager.swift
//  testWeather
//
//  Created by Алексей Моторин on 21.05.2022.
//

import RealmSwift

let realm = try!Realm()

class StorageManager {
    static func saveObject(_ city: WeatherCities) {
        try! realm.write {
            realm.add(city)
        }
    }
    
    static func deleteObject(_ city: WeatherCities) {
        try! realm.write {
            realm.delete(city)
        }
    }
}
