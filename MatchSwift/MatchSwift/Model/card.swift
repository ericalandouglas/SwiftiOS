//
//  Card.swift
//  MatchSwift
//
//  Created by Eric Douglas on 6/3/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import Foundation

class Card: NSObject {
    
    let contents: String
    var chosen = false
    var matched = false
    
    init(contents: String) {
        self.contents = contents
    }
    
    func match(otherCards: Card[]) -> Int {
        var score = 0
        for otherCard in otherCards {
            if otherCard.contents == self.contents {
                score = 1
            }
        }
        return score
    }
}
