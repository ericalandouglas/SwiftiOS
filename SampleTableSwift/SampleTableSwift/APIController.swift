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

class APIController: NSObject {
    
    var delegate: APIControllerProtocol?
    var data = NSMutableData()
    
    // Acquire Data Source
    
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+",
            options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        // Now escape anything else that isn't URL-friendly
        var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        var url = NSURL(string: urlPath)
        var request = NSURLRequest(URL: url)
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        connection.start()
    }
    
    // Connection Delegate Protocol
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Recieved a new request, clear out the data object
        self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        // Append the recieved chunk of data to our data object
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        // Request complete, self.data should now hold the resulting info
        // Convert the retrieved data in to an object through JSON deserialization
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data,
            options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        if jsonResult.count>0 && jsonResult["results"].count>0 {
            delegate?.didRecieveAPIResults(jsonResult)
        }
    }
   
}
