//
//  ViewController.swift
//  SampleTableSwift
//
//  Created by Eric Douglas on 6/6/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, APIControllerProtocol {
    
    @IBOutlet var appsTableView: UITableView
    @IBOutlet var searchTextField: UITextField
    @IBOutlet var searchButton: UIButton
    var tableData: NSArray = []
    var api = APIController()
    var imageCache: Dictionary<String, UIImage> = [:]
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.api.delegate = self
        self.searchButton.enabled = false
    }
    
    // Table View Delegate Protocol
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let kCellIdentifier = "SearchResultCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        var rowData = self.tableData[indexPath.row] as NSDictionary
        let cellText = rowData["trackName"] as? String
        cell.text = cellText
        cell.image = UIImage(named: "Blank52")
        // Jump in to a background thread to get the image for this item
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            var urlString = rowData["artworkUrl60"] as NSString
            // Check our image cache for the existing key. This is just a dictionary of UIImages
            var image = self.imageCache[urlString] as? UIImage
            if(!image?) {
                // If the image does not exist, we need to download it
                var imgURL = NSURL(string: urlString)
                // Download an NSData representation of the image at the URL
                var request = NSURLRequest(URL: imgURL)
                var urlConnection = NSURLConnection(request: request, delegate: self)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:
                {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    if !error? {
                        image = UIImage(data: data)
                        // Store the image in to our cache
                        self.imageCache[urlString] = image
                        cell.image = image
                    } else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
            } else {
                cell.image = image
            }
        })
        // Get the formatted price string for display in the subtitle
        var formattedPrice = rowData["formattedPrice"] as NSString
        cell.detailTextLabel.text = formattedPrice
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        // Get the row data for the selected row
        var rowData = self.tableData[indexPath.row] as NSDictionary
        var name = rowData["trackName"] as String
        var formattedPrice = rowData["formattedPrice"] as String
        var alert = UIAlertView()
        alert.title = name
        alert.message = formattedPrice
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    // API Protocol
    
    func didRecieveAPIResults(results: NSDictionary) {
        // Store the results in our table data array
        if results.count > 0 {
            self.tableData = results["results"] as NSArray
            self.appsTableView.reloadData()
        }
    }
    
    // Text Field Delegate Protocol
    
    func textFieldShouldBeginEditing(textField: UITextField!) -> Bool {
        self.searchButton.enabled = false
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if textField == self.searchTextField {
            textField.resignFirstResponder()
            if !textField.text.isEmpty {
                self.searchButton.enabled = true
            }
        }
        return true
    }
    
    // Respond to search button
    
    @IBAction func searchRequest(sender : UIButton) {
        let searchText = self.searchTextField.text
        api.searchItunesFor(searchText)
    }
}

