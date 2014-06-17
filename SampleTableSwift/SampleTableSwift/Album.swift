//
//  Album.swift
//  SampleTableSwift
//
//  Created by Eric Douglas on 6/9/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import Foundation

class Album {
    
    let title: String?
    let artist: String?
    let price: String?
    let thumbnailImageURL: String?
    let largeImageURL: String?
    let itemURL: String?
    let artistURL: String?
    let collectionId: Int?
    
    init(dict: NSDictionary!) {
        var name = dict["trackName"] as? String
        if !name? {
            name = dict["collectionName"] as? String
        }
        self.title = name
        self.artist = dict["artistName"] as? String
        // price comes in as formattedPrice or as collectionPrice or as a float
        var price = dict["formattedPrice"] as? String
        if !price? {
            price = dict["collectionPrice"] as? String
            if !price? {
                var priceFloat = dict["collectionPrice"] as? Float
                var nf = NSNumberFormatter()
                nf.maximumFractionDigits = 2;
                price = priceFloat? ? "$"+nf.stringFromNumber(priceFloat) : "No price"
            }
        }
        self.price = price
        self.thumbnailImageURL = dict["artworkUrl60"] as? String
        self.largeImageURL = dict["artworkUrl100"] as? String
        var itemURL = dict["collectionViewUrl"] as? String
        if !itemURL? {
            itemURL = dict["trackViewUrl"] as? String
        }
        self.itemURL = itemURL
        let optArtistURL = dict["artistViewUrl"] as? String
        self.artistURL = optArtistURL? ? optArtistURL : "No artist URL"
        self.collectionId = dict["collectionId"] as? Int
    }
    
}