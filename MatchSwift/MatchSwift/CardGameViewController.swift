//
//  ViewController.swift
//  MatchSwift
//
//  Created by Eric Douglas on 6/3/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import UIKit

class CardGameViewController: UIViewController {
    
    @lazy var deck = PlayingCardDeck()
    var flipCount: Int = 0 {
        didSet {
            self.flipLabel.text = "Flips: \(self.flipCount)"
        }
    }
    
    @IBOutlet var flipLabel: UILabel    

    @IBAction func touchCard(sender: UIButton) {
        ++self.flipCount
        if sender.currentTitle {
            sender.setBackgroundImage(UIImage(named: "cardback"), forState: UIControlState.Normal)
            sender.setTitle(nil, forState: UIControlState.Normal)
        } else {
            if self.deck.cards.count == 0 {
                sender.enabled = false
                --self.flipCount
            } else {
                let card = self.deck.drawRandomCard()
                sender.setBackgroundImage(UIImage(named: "cardfront"), forState: UIControlState.Normal)
                sender.setTitle(card.contents, forState: UIControlState.Normal)
            }
        }
    }

}

