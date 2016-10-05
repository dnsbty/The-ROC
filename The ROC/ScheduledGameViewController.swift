//
//  ScheduledGameViewController.swift
//  The ROC
//
//  Created by Dennis Beatty on 8/26/16.
//  Copyright © 2016 Dennis Beatty. All rights reserved.
//

import Foundation
import UIKit

class ScheduledGameViewController : UIViewController {
    
    // MARK: Properties
    var game: Game!
    
    // MARK: Outlets
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var venue: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var color: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if game.homeaway == Game.HomeAway.home {
            self.title = "\(game.sportString.capitalized) vs \(game.opponent)"
        } else {
            self.title = "\(game.sportString.capitalized) @ \(game.opponent)"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "MMM d"
        date.text = dateFormatter.string(from: game.datetime as Date)
        dateFormatter.dateFormat = "h:mm a"
        time.text = dateFormatter.string(from: game.datetime as Date)
        venue.text = game.venue
        city.text = game.city
        color.text = game.colorString.capitalized
    }
}
