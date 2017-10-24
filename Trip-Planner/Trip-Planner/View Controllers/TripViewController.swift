//
//  TripViewController.swift
//  Trip-Planner
//
//  Created by Duncan MacDonald on 10/20/17.
//  Copyright © 2017 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

class TripViewController: UIViewController {
    var trip: Trip! = nil
    
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var completedIndicator: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addWaypoint(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        self.tripNameTextField.text = self.trip.name
        self.completedIndicator.setOn(self.trip.isCompleted, animated: false)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard tripNameTextField.text != "" || tripNameTextField.text != nil else { return }
        
        let savedTrip = Trip(name: tripNameTextField.text!, owner: NetworkService.loggedInUser, isCompleted: self.completedIndicator.isOn, waypoints: trip.waypoints)
        
        NetworkService.putTrip(trip: savedTrip) { (code) in
            if let code = code {
                switch code {
                case 200:
                    print("Successfully saved trip")
                    DispatchQueue.main.async(execute: {
                        self.performSegue(withIdentifier: "toTripsView", sender: self)
                    })
                case 400:
                    print("Bad request when saving trip")
                default:
                    print("An unknown error occurred while trying to save a trip")
                }
            } else {
                print("Server error")
            }
        }
    }
}

extension TripViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trip!.waypoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WaypointCell = tableView.dequeueReusableCell(withIdentifier: "WaypointCell") as! WaypointCell
        cell.waypointCell.text = trip.waypoints[indexPath.row]
        return cell
    }
}
