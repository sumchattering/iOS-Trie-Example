//
//  CityListViewController.swift
//  CoolCities
//
//  Created by Sumeru Chatterjee on 09/07/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import UIKit

class CityListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar?
    
    var cityMapViewController: CityMapViewController? = nil
    var cities = [City]()
    let cityRepository = RepositoryInjection.provideCityRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = splitViewController {
            let controllers = split.viewControllers
            cityMapViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? CityMapViewController
        }
        self.searchBar?.delegate = self
        self.searchBar?.returnKeyType = .done
        self.loadCities()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - Cities
    
    private func loadCities(query: String? = nil) {
        cityRepository.getCities(prefix: query, completion: { [weak self] cities, _ in
            if let cities = cities {
                self?.cities = cities
                self?.tableView.reloadData()
            } else {
                // handle error
            }
        })
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let city = cities[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! CityMapViewController
                controller.city = city
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let city = cities[indexPath.row]
        cell.textLabel!.text = "\(city.name), \(city.country)"
        cell.detailTextLabel!.text = "(\(city.coord.lat), \(city.coord.lon))"
        return cell
    }

}

extension CityListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // to limit network activity, reload half a second after last key press.
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        self.perform(#selector(self.reload), with: nil, afterDelay: 0.3)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = self.searchBar?.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            loadCities()
            return
        }
        
        loadCities(query: query)
    }
}
