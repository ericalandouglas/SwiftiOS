//
//  playingcarddeck.swift
//  MatchSwift
//
//  Created by Eric Douglas on 6/4/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import Foundation

class PlayingCardDeck: Deck {
    
    init() {
        super.init()
        for suit in PlayingCard.validSuits() {
            for rank in 1...PlayingCard.maxRank() {
                self.cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
}