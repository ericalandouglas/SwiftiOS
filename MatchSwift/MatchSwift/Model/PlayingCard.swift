//
//  PlayingCard.swift
//  MatchSwift
//
//  Created by Eric Douglas on 6/4/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import Foundation

class PlayingCard: Card {
    
    let suit: String
    let rank: Int
    
    init(suit: String, rank: Int) {
        var suitSetValue = "?"
        for validSuit in PlayingCard.validSuits() {
            if validSuit == suit {
                suitSetValue = validSuit
            }
        }
        self.suit = suitSetValue
        var rankSetValue = 0
        if (0 <= rank) && (rank <= PlayingCard.maxRank()) {
            rankSetValue = rank
        }
        self.rank = rankSetValue
        super.init(contents: "\(PlayingCard.rankStrings()[self.rank])\(self.suit)")
    }
    
    class func rankStrings() -> String[] {
        return ["?", "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    }
    
    class func maxRank() -> Int {
        return rankStrings().count - 1
    }
    
    class func validSuits() -> String[] {
        return ["♠", "♥", "♦", "♣"]
    }

}
