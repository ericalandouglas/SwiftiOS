//
//  DetailsViewController.swift
//  SampleTableSwift
//
//  Created by Eric Douglas on 6/9/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var albumCover: UIImageView
    @IBOutlet var titleLabel: UILabel
    @IBOutlet var detailsTextView: UITextView
    @IBOutlet var openButton: UIButton
    
    var album: Album?
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.album?.artistURL
        self.albumCover.image = UIImage(data: NSData(contentsOfURL:
            NSURL(string: self.album?.largeImageURL)))
        self.detailsTextView.text = "Album: \((self.album?.title)!)\nArtist: \((self.album?.artist)!)"
    }
    
    @IBAction func openItunesLink() {
        if let urlString = self.album?.itemURL {
            UIApplication.sharedApplication().openURL(NSURL(string: urlString))
        }
    }
    
    // Search api for tracks in album example (id is collectionId):
    // https://itunes.apple.com/lookup?id=65621096&entity=song
    
}
