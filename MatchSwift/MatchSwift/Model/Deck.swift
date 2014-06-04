//
//  Deck.swift
//  MatchSwift
//
//  Created by Eric Douglas on 6/4/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import Foundation

class Deck {
    
    @lazy var cards = Card[]()
    
    func addCardTop(card: Card, onTop: Bool) {
        if onTop {
            self.cards.insert(card, atIndex: 0)
        } else {
            self.cards += card
        }
    }
    
    func addCard(card: Card) {
        self.addCardTop(card, onTop: false)
    }
    
    func drawRandomCard() -> Card {
        let index = Int(arc4random()) % self.cards.count
        return self.cards.removeAtIndex(index)
    }
    
}
