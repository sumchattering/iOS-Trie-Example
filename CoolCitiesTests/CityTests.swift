//
//  CityTests.swift
//  CoolCitiesTests
//
//  Created by Sumeru Chatterjee on 09/07/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import XCTest
import Foundation

@testable import CoolCities

class CityTests: XCTestCase {
    
    func testCityDecoding() {
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: "testcity", withExtension: "json")
        XCTAssertNotNil(fileURL)
        let testCityData = FileManager.default.contents(atPath: fileURL!.path)!
        XCTAssertNotNil(testCityData)
        
        var city: City?
        do {
            let decoder = JSONDecoder()
            city = try decoder.decode(City.self, from: testCityData)
        } catch let error {
            print(error)
        }
        
        XCTAssertEqual(city?.country, "UA")
        XCTAssertEqual(city?.name, "Hurzuf")
    }
    
    func testCitiesDecoding() {
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: "testcities", withExtension: "json")
        XCTAssertNotNil(fileURL)
        let testCityData = FileManager.default.contents(atPath: fileURL!.path)!
        XCTAssertNotNil(testCityData)
        
        var cities: [City]?
        do {
            let decoder = JSONDecoder()
            cities = try decoder.decode([City].self, from: testCityData)
        } catch let error {
            print(error)
        }
        
        XCTAssertEqual(cities?.count, 3)
    }
    
}
