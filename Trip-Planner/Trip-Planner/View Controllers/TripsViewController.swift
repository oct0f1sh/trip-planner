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
    var trips: [Trip] = []
    
}

extension TripsViewController: UITableViewDelegate {
    
}

extension TripsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trip = trips[indexPath.row]
        var cell: TripCell = tableView.dequeueReusableCell(withIdentifier: "TripCell") as! TripCell
        cell.tripNameLabel.text = trip.name
        
        return cell
    }
}
