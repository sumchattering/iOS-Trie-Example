//
//  RepositoryInjection.swift
//  CoolCities
//
//  Created by Sumeru Chatterjee on 09/07/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import Foundation

class RepositoryInjection {
    
    static let shared: RepositoryInjection = RepositoryInjection()
    
    lazy var cityRepository: CityRepository = { return CityRepositoryImplementation() }()
    
    static func provideCityRepository() -> CityRepository {
        return shared.cityRepository
    }
}

