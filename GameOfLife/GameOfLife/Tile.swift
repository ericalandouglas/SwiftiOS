//
//  Tile.swift
//  GameOfLife
//
//  Created by Eric Douglas on 6/17/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import SpriteKit

class Tile: SKSpriteNode {

    var isAlive: Bool = false {
        didSet {
            self.hidden = !self.isAlive
        }
    }
    var numLivingNeighbors = 0
    
}
