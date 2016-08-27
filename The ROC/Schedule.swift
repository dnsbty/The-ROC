//
//  Schedule.swift
//  The ROC
//
//  Created by Dennis Beatty on 8/26/16.
//  Copyright © 2016 Dennis Beatty. All rights reserved.
//

import Foundation
import Alamofire

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
    
    // MARK: Get latest schedule from the server
    func getLatest(completion: () -> Void) {
        Alamofire.request(APIRouter.Schedule())
            .responseJSON { response in
                // check if the response was successful
                guard response.result.isSuccess else {
                    print("Error while getting schedule: \(response.result.error)")
                    return
                }
                
                // make sure response types are as expected
                guard let responseJSON = response.result.value as? [AnyObject]
                    else {
                        print("Invalid information received when downloading the schedule")
                        return
                }
                
                self.parseGames(responseJSON)
                
                completion()
        }
    }
    
    // MARK: Helpers
    // MARK: Parse the games
    
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
            self.games.append(Game(datetime: datetime, sport: Game.Sport(rawValue: sport)!, opponent: opponent, homeaway: Game.HomeAway(rawValue: homeaway)!, color: Game.Color(rawValue: color)!, venue: venue, city: city, winloss: Game.WinLoss(rawValue: winloss)!, score_byu: score_byu, score_opponent: score_opponent))
        }
    }
}