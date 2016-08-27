//
//  Match.swift
//  The ROC
//
//  Created by Dennis Beatty on 8/26/16.
//  Copyright © 2016 Dennis Beatty. All rights reserved.
//

import Foundation

class Game {
    
    // MARK: Properties
    
    var datetime = NSDate()
    var sport = Sport.Football
    var opponent = ""
    var homeaway = HomeAway.Home
    var color = Color.White
    var venue = ""
    var city = ""
    var winloss = WinLoss.Unplayed
    var score_byu = 0
    var score_opponent = 0
    
    var sportString : String {
        switch sport {
        case Sport.Football:
            return "football"
        case Sport.MensBasketball:
            return "men's basketball"
        case Sport.WomensSoccer:
            return "women's soccer"
        case Sport.WomensVolleyball:
            return "women's volleyball"
        }
    }
    
    var colorString : String {
        switch color {
        case Color.Black:
            return "black"
        case Color.Navy:
            return "navy"
        case Color.White:
            return "white"
        case Color.Royal:
            return "royal blue"
        case Color.Other:
            return "any color"
        }
    }
    
    init(datetime: NSDate, sport: Sport, opponent: String, homeaway: HomeAway, color: Color, venue: String, city: String, winloss: WinLoss, score_byu: Int, score_opponent: Int) {
        self.datetime = datetime
        self.sport = sport
        self.opponent = opponent
        self.homeaway = homeaway
        self.color = color
        self.venue = venue
        self.city = city
        self.winloss = winloss
        self.score_byu = score_byu
        self.score_opponent = score_opponent
    }
    
    enum Sport: Int {
        case Football = 0, MensBasketball = 1, WomensSoccer = 2, WomensVolleyball = 3
    }
    
    enum HomeAway : Int {
        case Home = 0, Away = 1
    }
    
    enum Color : Int {
        case White = 0, Navy = 1, Royal = 2, Black = 3, Other = 4
    }
    
    enum WinLoss : Int {
        case Win = 0, Loss = 1, Tie = 2, Unplayed = 3
    }
}