//
//  ScheduleViewController.swift
//  The ROC
//
//  Created by Dennis Beatty on 8/26/16.
//  Copyright © 2016 Dennis Beatty. All rights reserved.
//

import Foundation
import UIKit

class ScheduleViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Schedule.shared.fetch({
            self.refreshTable()
        })
    }
    
    // MARK: Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell")!
        let game = Schedule.shared.games[(indexPath as NSIndexPath).row] 
        if game.homeaway == Game.HomeAway.home {
            cell.textLabel?.text = "\(game.sportString.capitalized) vs \(game.opponent)"
        } else {
            cell.textLabel?.text = "\(game.sportString.capitalized) @ \(game.opponent)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Schedule.shared.games.count
    }
    
    func refreshTable() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            return
        })
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Game Details" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let destVC = segue.destination as? ScheduledGameViewController {
                    destVC.game = Schedule.shared.games[(indexPath as NSIndexPath).row]
                }
            }
        }
    }
}
