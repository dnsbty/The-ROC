//
//  Schedule.swift
//  The ROC
//
//  Created by Dennis Beatty on 8/26/16.
//  Copyright © 2016 Dennis Beatty. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Schedule {
    
    // MARK: Properties
    var games = [Game]()
    
    // MARK: Singleton
    class var shared : Schedule {
        struct Singleton {
            static let instance = Schedule()
        }
        
        return Singleton.instance
    }
    
    private init() {
        // This guarantees that code outside this file can't instantiate a Schedule.
        // So others must use the shared singleton.
    }
    
    // MARK: Fetch schedule
    func fetch(completion: () -> Void) {
        let currentTime = NSDate()
        let lastFetchedTime = NSUserDefaults.standardUserDefaults().objectForKey("JSONDownloadTime") as? NSDate
        
        // check if we have a JSON file that was cached in the last week
        if (lastFetchedTime == nil || currentTime.isGreaterThanDate((lastFetchedTime?.addDays(7))!)) {
            // if not get the JSON file from the server
            self.getFromServer({
                jsonFilePath in
                self.parseSchedule({
                    completion()
                    return
                })
            })
        } else {
            // if we did grab it in the last week, make sure it exists at the saved path and parse it
            self.parseSchedule({
                completion()
                return
            })
        }
    }
    
    // MARK: Get latest schedule from the server
    func getFromServer(completion: (String) -> Void) {
        var localPath: NSURL?
        Alamofire.download(.GET,
            APIRouter.baseURL + "/json/schedule.json",
            destination: { (temporaryURL, response) in
                let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                let pathComponent = response.suggestedFilename
                
                localPath = directoryURL.URLByAppendingPathComponent(pathComponent!)
                return localPath!
        })
            .response { (request, response, _, error) in
                NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "JSONDownloadTime")
                completion(localPath!.absoluteString)
        }
    }
    
    // MARK: Helpers
    
    // MARK: Parse the schedule JSON file
    private func parseSchedule(completion: () -> Void) {
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("schedule.json")
            if let data = NSData(contentsOfURL: path) {
                let json = JSON(data: data).arrayObject
                self.parseGames(json!)
            } else {
                print("Schedule data was nil")
            }
        }
        completion()
    }
    
    // MARK: Parse the games from the schedule JSON file
    private func parseGames(games: [AnyObject]) {
        
        // clear the current games array
        self.games.removeAll()
        
        // iterate through all games in the array
        for index in 0 ..< games.count {
            
            // make sure the game has all expected fields
            guard let unixDateTime = games[index]["datetime"] as? Double,
                sport = games[index]["sport"] as? Int,
                opponent = games[index]["opponent"] as? String,
                homeaway = games[index]["homeaway"] as? Int,
                color = games[index]["color"] as? Int,
                venue = games[index]["venue"] as? String,
                city = games[index]["city"] as? String,
                winloss = games[index]["winloss"] as? Int,
                score_byu = games[index]["score_byu"] as? Int,
                score_opponent = games[index]["score_opponent"] as? Int
            else {
                    print("Invalid game information received")
                    return
            }
            
            // if so create a new game object, and append it to the array
            let datetime = NSDate(timeIntervalSince1970: unixDateTime / 1000)
            
            // make sure that the game hasn't already occurred
            if datetime.isLessThanDate(NSDate()) {
                continue
            }
            
            self.games.append(Game(datetime: datetime, sport: Game.Sport(rawValue: sport)!, opponent: opponent, homeaway: Game.HomeAway(rawValue: homeaway)!, color: Game.Color(rawValue: color)!, venue: venue, city: city, winloss: Game.WinLoss(rawValue: winloss)!, score_byu: score_byu, score_opponent: score_opponent))
        }
    }
}