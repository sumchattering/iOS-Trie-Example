//
//  CityMapViewController.swift
//  CoolCities
//
//  Created by Sumeru Chatterjee on 09/07/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import UIKit

class CityMapViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    func configureView() {
        // Update the user interface for the detail item.
        if let city = city {
            if let label = detailDescriptionLabel {
                label.text = city.name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var city: City? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

