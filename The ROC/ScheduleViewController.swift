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
        
        Schedule.shared.getLatest({
            self.refreshTable()
        })
    }
    
    // MARK: Table view data source
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GameCell")!
        let game = Schedule.shared.games[indexPath.row] 
        if game.homeaway == Game.HomeAway.Home {
            cell.textLabel?.text = "\(game.sportString.capitalizedString) vs \(game.opponent)"
        } else {
            cell.textLabel?.text = "\(game.sportString.capitalizedString) @ \(game.opponent)"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Schedule.shared.games.count
    }
    
    func refreshTable() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Game Details" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let destVC = segue.destinationViewController as? ScheduledGameViewController {
                    destVC.game = Schedule.shared.games[indexPath.row]
                }
            }
        }
    }
}
