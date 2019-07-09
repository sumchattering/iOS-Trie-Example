//
//  CityRepository.swift
//  CoolCities
//
//  Created by Sumeru Chatterjee.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import Foundation

typealias GetCitiesCompletion = ([City]?, Error?)->()

protocol CityRepository {

    func preloadCities()

    func getCities(prefix: String?, completion: GetCitiesCompletion)

}
