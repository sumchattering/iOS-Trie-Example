//
//  City.swift
//  CoolCities
//
//  Created by Sumeru Chatterjee on 09/07/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import Foundation

//Sample JSON: {"country":"UA","name":"Hurzuf","_id":707860,"coord":{"lon":34.283333,"lat":44.549999}},

import Foundation

struct City: Codable, Hashable {
    
    let identifier: Int64
    let country: String
    let name: String
    let coord: CityCoord
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "_id", country, name, coord
    }
}

struct CityCoord: Codable, Hashable {
    
    let lat: Double
    let lon: Double
}

