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
    
    var datetime = Date()
    var sport = Sport.football
    var opponent = ""
    var homeaway = HomeAway.home
    var color = Color.white
    var venue = ""
    var city = ""
    var winloss = WinLoss.unplayed
    var score_byu = 0
    var score_opponent = 0
    
    var sportString : String {
        switch sport {
        case Sport.football:
            return "football"
        case Sport.mensBasketball:
            return "men's basketball"
        case Sport.womensSoccer:
            return "women's soccer"
        case Sport.womensVolleyball:
            return "women's volleyball"
        }
    }
    
    var colorString : String {
        switch color {
        case Color.black:
            return "black"
        case Color.navy:
            return "navy"
        case Color.white:
            return "white"
        case Color.royal:
            return "royal blue"
        case Color.other:
            return "any color"
        }
    }
    
    init(datetime: Date, sport: Sport, opponent: String, homeaway: HomeAway, color: Color, venue: String, city: String, winloss: WinLoss, score_byu: Int, score_opponent: Int) {
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
        case football = 0, mensBasketball = 1, womensSoccer = 2, womensVolleyball = 3
    }
    
    enum HomeAway : Int {
        case home = 0, away = 1
    }
    
    enum Color : Int {
        case white = 0, navy = 1, royal = 2, black = 3, other = 4
    }
    
    enum WinLoss : Int {
        case win = 0, loss = 1, tie = 2, unplayed = 3
    }
}
