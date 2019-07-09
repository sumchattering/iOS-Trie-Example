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
        let expectation = self.expectation(description: "SomeCities")
        
        cityRepository?.getCities(prefix: "al", completion: { cities, error in
            XCTAssertNil(error)
            XCTAssertNotNil(cities)
            XCTAssert(cities!.count > 0)
            XCTAssertEqual(cities?.count, 3019)
            for city in cities! {
                XCTAssertTrue(city.name.lowercased().hasPrefix("al"))
            }
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
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

