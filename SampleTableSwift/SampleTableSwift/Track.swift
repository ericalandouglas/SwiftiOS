//
//  Track.swift
//  SampleTableSwift
//
//  Created by Eric Douglas on 6/16/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import Foundation

class Track {
    
    var title: String?
    var price: String?
    var previewUrl: String?
    
    init(dict: NSDictionary!) {
        self.title = dict["trackName"] as? String
        self.price = dict["trackPrice"] as? String
        self.previewUrl = dict["previewUrl"] as? String
    }
    
}