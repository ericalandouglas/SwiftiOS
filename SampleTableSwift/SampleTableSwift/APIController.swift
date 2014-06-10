//
//  APIController.swift
//  SampleTableSwift
//
//  Created by Eric Douglas on 6/6/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import UIKit

protocol APIControllerProtocol {
    func didRecieveAPIResults(results: NSDictionary)
}

class APIController {
    
    var delegate: APIControllerProtocol?
    
    init(delegate: APIControllerProtocol?) {
        self.delegate = delegate
    }
    
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+",
            options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        // Now escape anything else that isn't URL-friendly
        var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        // Album API
        var urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
        var url = NSURL(string: urlPath)
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:
            {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error? {
                println("ERROR: \(error.localizedDescription)")
            } else {
                var error: NSError?
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
                    as NSDictionary
                if error? {
                    println("HTTP Error: \(error!.localizedDescription)")
                } else {
                    self.delegate?.didRecieveAPIResults(jsonResult)
                }
            }
        })
    }
    
}
