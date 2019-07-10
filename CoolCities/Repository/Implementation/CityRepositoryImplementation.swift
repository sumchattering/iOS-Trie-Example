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
    
    var cityTrie: CityTrie?
    var allCities: [City]?
    
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
        
        let sortedCities = allCities.sorted(by: { city1, city2 in
            if city1.name != city2.name { 
                return city1.name < city2.name
            } else {
                return city1.country < city2.country
            }
        })
        
        self.allCities = sortedCities
        self.cityTrie = CityTrie()
        for city in sortedCities {
            self.cityTrie?.insert(city: city)
        }
    }
    
    func getCities(prefix: String?, completion: GetCitiesCompletion) {
        
        guard let cityTrie = cityTrie, let allCities = allCities, cityTrie.count > 0, allCities.count > 0 else {
            completion(nil, CityRepositoryError.initializationError)
            return
        }
        
        guard let lowercasePrefix = prefix?.lowercased() else {
            completion(allCities, nil)
            return
        }
        
        let filteredCities = cityTrie.findCitiesWithPrefix(prefix: lowercasePrefix)
        completion(filteredCities, nil)
    }
    
}
