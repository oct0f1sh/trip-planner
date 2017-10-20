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
    
    override func awakeFromNib() {
        NetworkService.getTrips { (trips) in
            if let trips = trips {
                self.trips = trips
            }
        }
    }
    
    @IBAction func addTripTapped(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            let tripView = segue.destination as! TripViewController
            tripView.trip = trips[selectedRow]
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
