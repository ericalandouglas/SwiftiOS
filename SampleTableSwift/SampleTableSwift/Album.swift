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
    
    init(name: String!, artist: String!, price: String!, thumbnailImageURL: String!, largeImageURL: String!, itemURL: String!, artistURL: String!) {
        self.title = name
        self.artist = artist
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
    }
    
}