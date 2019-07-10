//
//  CityTrieTests.swift
//  CoolCitiesTests
//
//  Created by Sumeru Chatterjee on 09/07/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import XCTest
@testable import CoolCities

class CityTrieTests: XCTestCase {
    
    let cityAlangulam = City(identifier: 1279058, country: "IN", name: "Alangulam", coord: CityCoord(lat: 8.86667, lon: 77.5))
    let cityAlangayam = City(identifier: 1279061, country: "IN", name: "Alangayam", coord: CityCoord(lat: 12.6, lon: 78.75))
    let cityAlandur = City(identifier: 1279064, country: "IN", name: "Alandur", coord: CityCoord(lat: 13.0025, lon: 80.206108))
    let cityHokkaido = City(identifier: 1279064, country: "JP", name: "Hokkaidō", coord: CityCoord(lat: 43.06451, lon: 141.346603))
    
    var fullCityArray: [City]?
    func createFullCityArray() {
        guard fullCityArray == nil else {
            return
        }
        
        let fileURL = Bundle.main.url(forResource: "cities", withExtension: "json")
        XCTAssertNotNil(fileURL)
        
        let cityData = FileManager.default.contents(atPath: fileURL!.path)
        XCTAssertNotNil(cityData)
        
        do {
            let decoder = JSONDecoder()
            fullCityArray = try decoder.decode([City].self, from: cityData!)
        } catch let error {
            print(error)
        }
        
        XCTAssertNotNil(fullCityArray)
        XCTAssert(fullCityArray!.count > 0)
    }
    
    var smallCityArray: [City]?
    func createSmallCityArray() {
        guard smallCityArray == nil else {
            return
        }
        
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: "citiestestdata", withExtension: "json")
        XCTAssertNotNil(fileURL)
        
        let cityData = FileManager.default.contents(atPath: fileURL!.path)
        XCTAssertNotNil(cityData)
        
        do {
            let decoder = JSONDecoder()
            smallCityArray = try decoder.decode([City].self, from: cityData!)
        } catch let error {
            print(error)
        }
        
        XCTAssertNotNil(smallCityArray)
        XCTAssert(smallCityArray!.count > 0)
    }
    
    /// Tests that a newly created trie has zero words.
    func testCreate() {
        let trie = CityTrie()
        XCTAssertEqual(trie.count, 0)
    }
    
    /// Tests the insert method
    func testInsert() {
        let trie = CityTrie()
        trie.insert(city: cityAlandur)
        trie.insert(city: cityAlangayam)
        trie.insert(city: cityHokkaido)
        XCTAssertTrue(trie.contains(city: cityAlandur))
        XCTAssertFalse(trie.contains(city: cityAlangulam))
        trie.insert(city: cityAlangulam)
        XCTAssertTrue(trie.contains(city: cityAlangulam))
        XCTAssertEqual(trie.count, 4)
    }
    
    /// Tests the remove method
    func testRemove() {
        let trie = CityTrie()
        trie.insert(city: cityAlandur)
        trie.insert(city: cityAlangayam)
        XCTAssertEqual(trie.count, 2)
        trie.remove(city: cityAlandur)
        XCTAssertTrue(trie.contains(city: cityAlangayam))
        XCTAssertFalse(trie.contains(city: cityAlandur))
        XCTAssertEqual(trie.count, 1)
    }
    
    /// Tests the words property
    func testWords() {
        let trie = CityTrie()
        var cities = trie.cities
        XCTAssertEqual(cities.count, 0)
        trie.insert(city: cityAlangulam)
        cities = trie.cities
        XCTAssertEqual(cities[0], cityAlangulam)
        XCTAssertEqual(cities.count, 1)
    }
    
    /// Tests the performance of the insert method.
    func testSmallInsertPerformance() {
        createSmallCityArray()
        
        var trie: CityTrie?
        self.measure {
            trie = CityTrie()
            for city in self.smallCityArray! {
                trie!.insert(city: city)
            }
        }
        XCTAssertGreaterThan(trie!.count, 0)
        XCTAssertEqual(trie!.count, smallCityArray?.count)
    }
    
    /// Tests the performance of the insert method.
    func testFullInsertPerformance() {
        createFullCityArray()
        
        var trie: CityTrie?
        self.measure {
            trie = CityTrie()
            for city in self.fullCityArray! {
                trie!.insert(city: city)
            }
        }
        XCTAssertGreaterThan(trie!.count, 0)
        XCTAssertEqual(trie!.count, fullCityArray?.count)
    }
    
    func testFindWordsWithPrefixSmall() {
        createSmallCityArray()
        let trie = CityTrie()
        for city in smallCityArray! {
            trie.insert(city: city)
        }
        
        let citiesStartingWithATrue = smallCityArray?.filter({ $0.name.lowercased().hasPrefix("a")  })
        
        let citiesStartingWithA1 = trie.findCitiesWithPrefix(prefix: "A")
        XCTAssertNotNil(citiesStartingWithA1)
        for city in citiesStartingWithATrue! {
            if !citiesStartingWithA1.contains(city) {
                XCTFail("Could not find city \(city)")
            }
        }
        XCTAssert(citiesStartingWithA1.count == citiesStartingWithATrue?.count)
        
        let citiesStartingWithA2 = trie.findCitiesWithPrefix(prefix: "a")
        XCTAssertNotNil(citiesStartingWithA2)
        for city in citiesStartingWithATrue! {
            if !citiesStartingWithA2.contains(city) {
                XCTFail("Could not find city \(city)")
            }
        }
        XCTAssert(citiesStartingWithA2.count == citiesStartingWithATrue?.count)
        XCTAssertEqual(citiesStartingWithA1, citiesStartingWithA2)
    }
    
    func testFindWordsWithPrefixFull() {
        createFullCityArray()
        let trie = CityTrie()
        for city in fullCityArray! {
            trie.insert(city: city)
        }
        
        let citiesStartingWithATrue = fullCityArray?.filter({ $0.name.lowercased().hasPrefix("al")  })

        let citiesStartingWithAl1 = trie.findCitiesWithPrefix(prefix: "Al")
        XCTAssertNotNil(citiesStartingWithAl1)
        XCTAssert(citiesStartingWithAl1.count == citiesStartingWithATrue?.count)
        
        let citiesStartingWithAl2 = trie.findCitiesWithPrefix(prefix: "al")
        XCTAssertNotNil(citiesStartingWithAl2)
        XCTAssert(citiesStartingWithAl2.count == citiesStartingWithATrue?.count)
        
        XCTAssertEqual(citiesStartingWithAl1, citiesStartingWithAl2)
    }

    func testFindWordsWithPrefixPerformance() {
        createFullCityArray()
        let trie = CityTrie()
        for city in fullCityArray! {
            trie.insert(city: city)
        }
        var citiesStartingWithAl: [City]?
        self.measure {
            citiesStartingWithAl = trie.findCitiesWithPrefix(prefix: "Al")
        }
        
        XCTAssertNotNil(citiesStartingWithAl)
    }
}
