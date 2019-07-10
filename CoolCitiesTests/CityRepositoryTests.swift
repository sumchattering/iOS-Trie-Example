//
//  CityRepositoryTests.swift
//  CoolCitiesTests
//
//  Created by Sumeru Chatterjee on 09/07/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import XCTest
import Foundation

@testable import CoolCities

class CityRepositoryTests: XCTestCase {
    
    var cityRepository: CityRepository?

    override func setUp() {
        cityRepository = RepositoryInjection.provideCityRepository()
    }
    
    func testGetAllCities() {
        let expectation = self.expectation(description: "AllCities")
        
        cityRepository?.getCities(prefix: nil, completion: { cities, error in
            XCTAssertNil(error)
            XCTAssertNotNil(cities)
            XCTAssert(cities!.count > 0)
            expectation.fulfill()
        })
    
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPerformanceGetAllCities() {
        self.measureMetrics([.wallClockTime], automaticallyStartMeasuring: true, for: {
            let expectation = self.expectation(description: "AllCities")
            cityRepository?.getCities(prefix: nil, completion: { cities, error in
                XCTAssert(cities!.count > 0)
                expectation.fulfill()
            })
            waitForExpectations(timeout: 5, handler: { error in
                self.stopMeasuring()
            })
        })
    }
    
    func testGetSomeCities() {
        var allCities: [City]?
        let expectation1 = self.expectation(description: "AllCities")
        cityRepository?.getCities(prefix: nil, completion: { cities, error in
            allCities = cities
            expectation1.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(allCities)
        XCTAssert(allCities!.count == 209557)
        
        let filteredCities = allCities?.filter({ city in
            return city.name.lowercased().hasPrefix("al")
        })
        
        var returnedFilteredCities: [City]?
        let expectation2 = self.expectation(description: "SomeCities")
        cityRepository?.getCities(prefix: "al", completion: { cities, error in
            returnedFilteredCities = cities
            expectation2.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(returnedFilteredCities)
        XCTAssert(returnedFilteredCities!.count > 0)
        for city in filteredCities! {
            if !returnedFilteredCities!.contains(city) {
                XCTFail("Coult not find \(city.name)")
            }
        }
        
        for city in returnedFilteredCities! {
            XCTAssertTrue(city.name.lowercased().hasPrefix("al"))
        }
    }
    
    func testPerformanceGetSomeCities() {
        self.measureMetrics([.wallClockTime], automaticallyStartMeasuring: true, for: {
            let expectation = self.expectation(description: "SomeCities")
            cityRepository?.getCities(prefix: "al", completion: { cities, error in
                expectation.fulfill()
            })
            waitForExpectations(timeout: 5, handler: { error in
                self.stopMeasuring()
            })
        })
    }
}

