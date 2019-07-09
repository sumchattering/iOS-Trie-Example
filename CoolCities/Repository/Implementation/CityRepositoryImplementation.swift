//
//  CityRepositoryImplementation.swift
//  CoolCities
//
//  Created by Sumeru Chatterjee on 09/07/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import Foundation

enum CityRepositoryError: Error {
    case initializationError
    case unknownError
}

class CityRepositoryImplementation: CityRepository {
    
    var cities: [City]?
    
    func preloadCities() {
        guard let fileURL = Bundle.main.url(forResource: "cities", withExtension: "json") else {
            print("Error: Could not find cities.json")
            return
        }
        
        guard let cityData = FileManager.default.contents(atPath: fileURL.path) else {
            print("Error: Could not load cities.json")
            return
        }
        
        var cities: [City]?
        do {
            let decoder = JSONDecoder()
            cities = try decoder.decode([City].self, from: cityData)
        } catch let error {
            print(error)
        }
        
        guard let allCities = cities else {
            print("Error: could not decode cities.json")
            return
        }
        
        self.cities = allCities
    }
    
    func getCities(prefix: String?, completion: GetCitiesCompletion) {
        
        guard let cities = self.cities else {
            completion(nil, CityRepositoryError.initializationError)
            return
        }
        
        guard let lowercasePrefix = prefix?.lowercased() else {
            completion(cities, nil)
            return
        }
        
        let filteredCities = cities.filter { city in
            let citynameLowercase = city.name.lowercased()
            return citynameLowercase.hasPrefix(lowercasePrefix)
        }
        
        completion(filteredCities, nil)
    }
    
}
