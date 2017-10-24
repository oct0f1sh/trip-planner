//
//  TripViewController.swift
//  Trip-Planner
//
//  Created by Duncan MacDonald on 10/20/17.
//  Copyright © 2017 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

enum TripType {
    case newTrip
    case editTrip
}

class TripViewController: UIViewController {
    var trip: Trip! = nil
    var tripType: TripType = .editTrip
    
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var completedIndicator: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addWaypoint(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        if tripType == .editTrip {
            self.tripNameTextField.text = self.trip.name
            self.completedIndicator.setOn(self.trip.isCompleted, animated: false)
        } else {
            self.trip = Trip(name: "", owner: NetworkService.loggedInUser)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard tripNameTextField.text != "" || tripNameTextField.text != nil else { return }
        
        let savedTrip = Trip(id: trip.id, name: tripNameTextField.text!, email: NetworkService.loggedInUser.email, isCompleted: completedIndicator.isOn, waypoints: trip.waypoints)
        
        if self.tripType == .editTrip {
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
        } else {
            NetworkService.postTrip(trip: savedTrip, completion: { (code) in
                if let code = code {
                    switch code {
                    case 400:
                        DispatchQueue.main.async(execute: {
                            self.showAlert(title: "Error", message: "A trip with that name already exists.", actionText: "Ok")
                        })
                    case 201:
                        print("Trip created successfully")
                        DispatchQueue.main.async(execute: {
                            self.performSegue(withIdentifier: "toTripsView", sender: self)
                            self.tableView.reloadData()
                        })
                    default:
                        print("Error posting trip")
                    }
                }
            })
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        self.showInputTextAlert(title: "Add a waypoint", message: "Enter the name of the waypoint you would like to add", placeholder: "Waypoint") { (waypoint) in
            if let waypoint = waypoint {
                self.trip.waypoints.append(waypoint)
                self.tableView.reloadData()
            }
        }
    }
}

extension TripViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard trip != nil else {
            return 0
        }
        return self.trip!.waypoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WaypointCell = tableView.dequeueReusableCell(withIdentifier: "WaypointCell") as! WaypointCell
        cell.waypointCell.text = trip.waypoints[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
}

extension TripViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.trip.waypoints.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
}
