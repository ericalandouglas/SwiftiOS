//
//  GameScene.swift
//  GameOfLife
//
//  Created by Eric Douglas on 6/17/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let gridWidth = 400
    let gridHeight = 300
    let numRows = 8
    let numCols = 10
    let gridLowerLeftCorner = CGPoint(x: 158, y: 10)
    let populationLabel = SKLabelNode(text: "Population")
    let generationLabel = SKLabelNode(text: "Generation")
    var populationValueLabel = SKLabelNode(text: "0")
    var generationValueLabel = SKLabelNode(text: "0")
    var playButton = SKSpriteNode(imageNamed:"play.png")
    var pauseButton = SKSpriteNode(imageNamed:"pause.png")
    var tiles = Tile[][]()
    let margin = 4
    var tileSize: CGSize {
        get {
            let tileWidth = self.gridWidth / self.numCols - self.margin
            let tileHeight = self.gridHeight / self.numRows - self.margin
            return CGSize(width: tileWidth, height: tileHeight)
        }
    }
    var isPlaying = false
    var prevTime:CFTimeInterval = 0
    var timeCounter:CFTimeInterval = 0
    var population:Int = 0 {
        didSet {
            self.populationValueLabel.text = "\(self.population)"
        }
    }
    var generation:Int = 0 {
        didSet {
            self.generationValueLabel.text = "\(self.generation)"
        }
    }
    
    override func didMoveToView(view: SKView) {
        // add the background image
        let background = SKSpriteNode(imageNamed: "background.png")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.size = self.size
        background.zPosition = -2
        self.addChild(background)
        // add the grid background
        let gridBackground = SKSpriteNode(imageNamed: "grid.png")
        gridBackground.size = CGSize(width: self.gridWidth, height: self.gridHeight)
        gridBackground.zPosition = -1
        gridBackground.anchorPoint = CGPoint(x:0, y:0)
        gridBackground.position = self.gridLowerLeftCorner
        self.addChild(gridBackground)
        // add the play button
        self.playButton.position = CGPoint(x: 79, y: 290)
        self.playButton.setScale(0.5)
        self.addChild(self.playButton)
        // add the pause button
        self.pauseButton.position = CGPoint(x: 79, y: 250)
        self.pauseButton.setScale(0.5)
        self.addChild(self.pauseButton)
        // add the balloon background for the stats
        let balloon = SKSpriteNode(imageNamed: "balloon.png")
        balloon.position = CGPoint(x: 79, y: 170)
        balloon.setScale(0.5)
        self.addChild(balloon)
        // add the microscope image as a decoration
        let microscope = SKSpriteNode(imageNamed: "microscope.png")
        microscope.position = CGPoint(x: 79, y: 70)
        microscope.setScale(0.4)
        self.addChild(microscope)
        // dark green labels to keep track of number of living tiles
        // and number of steps the simulation has gone through
        self.populationLabel.position = CGPoint(x: 79, y: 190)
        self.populationLabel.fontName = "Courier"
        self.populationLabel.fontSize = 12
        self.populationLabel.fontColor = UIColor(red: 0, green: 0.2, blue: 0, alpha: 1)
        self.addChild(self.populationLabel)
        self.generationLabel.position = CGPoint(x: 79, y: 160)
        self.generationLabel.fontName = "Courier"
        self.generationLabel.fontSize = 12
        self.generationLabel.fontColor = UIColor(red: 0, green: 0.2, blue: 0, alpha: 1)
        self.addChild(self.generationLabel)
        self.populationValueLabel.position = CGPoint(x: 79, y: 175)
        self.populationValueLabel.fontName = "Courier"
        self.populationValueLabel.fontSize = 12
        self.populationValueLabel.fontColor = UIColor(red: 0, green: 0.2, blue: 0, alpha: 1)
        self.addChild(self.populationValueLabel)
        self.generationValueLabel.position = CGPoint(x: 79, y: 145)
        self.generationValueLabel.fontName = "Courier"
        self.generationValueLabel.fontSize = 12
        self.generationValueLabel.fontColor = UIColor(red: 0, green: 0.2, blue: 0, alpha: 1)
        self.addChild(self.generationValueLabel)
        // initialize the 2d array of tiles
        for r in 0..self.numRows {
            var tileRow = Tile[]()
            for c in 0..self.numCols {
                let tile = Tile(imageNamed: "bubble.png")
                tile.isAlive = false
                tile.size = CGSize(width: self.tileSize.width, height: self.tileSize.height)
                tile.anchorPoint = CGPoint(x: 0, y: 0)
                tile.position = getTilePosition(row: r, column: c)
                self.addChild(tile)
                tileRow.append(tile)
            }
            self.tiles.append(tileRow)
        }
    }
    
    func getTilePosition(row r:Int, column c:Int) -> CGPoint {
        let x = Int(self.gridLowerLeftCorner.x) + self.margin
            + (c * (Int(self.tileSize.width) + self.margin))
        let y = Int(self.gridLowerLeftCorner.y) + self.margin
            + (r * (Int(self.tileSize.height) + self.margin))
        return CGPoint(x: x, y: y)
    }
    
    func isValidTile(row r: Int, column c:Int) -> Bool {
        return r >= 0 && r < self.numRows && c >= 0 && c < self.numCols
    }
    
    func getTileAtPosition(xPos x: Int, yPos y: Int) -> Tile? {
        let r = Int(CGFloat(y - (Int(self.gridLowerLeftCorner.y) + self.margin)) / CGFloat(self.gridHeight) * CGFloat(self.numRows))
        let c = Int(CGFloat(x - (Int(self.gridLowerLeftCorner.x) + self.margin)) / CGFloat(self.gridWidth) * CGFloat(self.numCols))
        return isValidTile(row: r, column: c) ? self.tiles[r][c] : nil
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            var selectedTile = self.getTileAtPosition(
                xPos: Int(touch.locationInNode(self).x),
                yPos: Int(touch.locationInNode(self).y))
            if let tile = selectedTile {
                tile.isAlive = !tile.isAlive
                tile.isAlive ? ++self.population : --self.population
            }
            if CGRectContainsPoint(self.playButton.frame, touch.locationInNode(self)) {
                self.playButtonPressed()
            }
            if CGRectContainsPoint(self.pauseButton.frame, touch.locationInNode(self)) {
                self.pauseButtonPressed()
            }
        }
    }
    
    func playButtonPressed() {
        self.isPlaying = true
    }
    
    func pauseButtonPressed() {
        self.isPlaying = false
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if self.prevTime == 0 {
            self.prevTime = currentTime
        }
        if self.isPlaying {
            self.timeCounter += currentTime - self.prevTime
            if self.timeCounter > 0.5 {
                self.timeCounter = 0
                self.timeStep()
            }
        }
        self.prevTime = currentTime
    }
    
    func timeStep() {
        self.countLivingNeighbors()
        self.updateCreatures()
        ++self.generation
    }
    
    func countLivingNeighbors() {
        for r in 0..self.numRows {
            for c in 0..self.numCols {
                var numLivingNeighbors = 0
                for i in (r-1)...(r+1) {
                    for j in (c-1)...(c+1) {
                        if (!((r == i) && (c == j)) && isValidTile(row: i, column: j)) {
                            if self.tiles[i][j].isAlive {
                                ++numLivingNeighbors
                            }
                        }
                    }
                }
                self.tiles[r][c].numLivingNeighbors = numLivingNeighbors
            }
        }
    }
    
    func updateCreatures() {
        var numAlive = 0
        for r in 0..self.numRows {
            for c in 0..self.numCols {
                var tile = self.tiles[r][c]
                if tile.numLivingNeighbors == 3 {
                    tile.isAlive = true
                } else if tile.numLivingNeighbors < 2 || tile.numLivingNeighbors > 3 {
                    tile.isAlive = false
                }
                if tile.isAlive {
                    ++numAlive
                }
            }
        }
        self.population = numAlive
    }
    
}
