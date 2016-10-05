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
    
    fileprivate init() {
        // This guarantees that code outside this file can't instantiate a Schedule.
        // So others must use the shared singleton.
    }
    
    // MARK: Fetch schedule
    func fetch(_ completion: @escaping () -> Void) {
        let currentTime = Date()
        let lastFetchedTime = UserDefaults.standard.object(forKey: "JSONDownloadTime") as? Date
        
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
    func getFromServer(_ completion: @escaping (String) -> Void) {
        var localPath: URL?
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("schedule.json")
            localPath = fileURL
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(Router.schedule(), to: destination).response { response in
            print(response)
            UserDefaults.standard.set(NSDate(), forKey: "JSONDownloadTime")
            completion(localPath!.absoluteString)
        }
    }
    
    // MARK: Helpers
    
    // MARK: Parse the schedule JSON file
    fileprivate func parseSchedule(_ completion: () -> Void) {
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = URL(fileURLWithPath: dir).appendingPathComponent("schedule.json")
            if let data = try? Data(contentsOf: path) {
                let json = JSON(data: data).arrayObject
                self.parseGames(json! as [AnyObject])
            } else {
                print("Schedule data was nil")
            }
        }
        completion()
    }
    
    // MARK: Parse the games from the schedule JSON file
    fileprivate func parseGames(_ games: [AnyObject]) {
        
        // clear the current games array
        self.games.removeAll()
        
        // iterate through all games in the array
        for index in 0 ..< games.count {
            
            // make sure the game has all expected fields
            guard let unixDateTime = games[index]["datetime"] as? Double,
                let sport = games[index]["sport"] as? Int,
                let opponent = games[index]["opponent"] as? String,
                let homeaway = games[index]["homeaway"] as? Int,
                let color = games[index]["color"] as? Int,
                let venue = games[index]["venue"] as? String,
                let city = games[index]["city"] as? String,
                let winloss = games[index]["winloss"] as? Int,
                let score_byu = games[index]["score_byu"] as? Int,
                let score_opponent = games[index]["score_opponent"] as? Int
            else {
                    print("Invalid game information received")
                    return
            }
            
            // if so create a new game object, and append it to the array
            let datetime = Date(timeIntervalSince1970: unixDateTime / 1000)
            
            // make sure that the game hasn't already occurred
            if datetime.isLessThanDate(Date()) {
                continue
            }
            
            self.games.append(Game(datetime: datetime, sport: Game.Sport(rawValue: sport)!, opponent: opponent, homeaway: Game.HomeAway(rawValue: homeaway)!, color: Game.Color(rawValue: color)!, venue: venue, city: city, winloss: Game.WinLoss(rawValue: winloss)!, score_byu: score_byu, score_opponent: score_opponent))
        }
    }
}
