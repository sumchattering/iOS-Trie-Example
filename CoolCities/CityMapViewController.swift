//
//  CityMapViewController.swift
//  CoolCities
//
//  Created by Sumeru Chatterjee on 09/07/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import UIKit
import MapKit

class CityMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    func configureView() {
        // Update the user interface for the detail item.
        if let city = city, isViewLoaded {
            self.title = city.name
            self.addPin(title: city.name, coord: city.coord)
            self.focusMapView(coord: city.coord)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(type: .infoDark)
        button.addTarget(self, action: #selector(self.showInfoScreen), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        // Do any additional setup after loading the view.
        configureView()
    }

    var city: City? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    @objc private func showInfoScreen() {
        
    }

    private func addPin(title: String, coord: CityCoord) {
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lon)
        annotation.coordinate = centerCoordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    private func focusMapView(coord: CityCoord) {
        let mapCenter = CLLocationCoordinate2DMake(coord.lat, coord.lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: mapCenter, span: span)
        mapView.region = region
    }
}

