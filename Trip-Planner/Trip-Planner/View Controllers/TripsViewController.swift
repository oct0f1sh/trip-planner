//
//  TripsViewController.swift
//  Trip-Planner
//
//  Created by Duncan MacDonald on 10/17/17.
//  Copyright © 2017 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

class TripsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var trips: [Trip] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NetworkService.getTrips { (allTrips) in
            if let allTrips = allTrips {
                self.trips = allTrips
            }
        }
    }
    
    @IBAction func addTripTapped(_ sender: Any) {
        performSegue(withIdentifier: "toEditTrip", sender: self)
    }
    
    @IBAction func unwindToTrips(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            let tripView = segue.destination as! TripViewController
            tripView.trip = trips[selectedRow]
        } else {
            let tripView = segue.destination as! TripViewController
            tripView.tripType = .newTrip
        }
    }
}

extension TripsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trip = trips[indexPath.row]
        let cell: TripCell = tableView.dequeueReusableCell(withIdentifier: "TripCell") as! TripCell
        cell.tripNameLabel.text = trip.name
        
        return cell
    }
}
