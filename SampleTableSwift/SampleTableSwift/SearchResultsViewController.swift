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
    var albums = Album[]()
    var api: APIController?
    var imageCache = Dictionary<String, UIImage>()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = APIController(delegate: self)
        self.searchButton.enabled = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        if segue.identifier == "Album Details" {
            let detailsViewController = segue.destinationViewController as DetailsViewController
            let albumIndex = appsTableView.indexPathForSelectedRow().row
            detailsViewController.album = self.albums[albumIndex]
        }
    }
    
    // Table View Delegate Protocol
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let kCellIdentifier = "SearchResultCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        let album = self.albums[indexPath.row]
        cell.text = album.title
        cell.detailTextLabel.text = album.price
        cell.image = UIImage(named: "Blank52")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // Check our image cache for the existing key. This is just a dictionary of UIImages
            let urlString = album.thumbnailImageURL
            var image = self.imageCache[urlString!]
            if !image? {
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
                        self.imageCache[urlString!] = image
                        if let albumArtsCell: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath) {
                            albumArtsCell!.image = image
                        }
                    } else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
            } else {
                cell.image = image
            }
        })
        return cell
    }
    
    // API Protocol
    
    func didRecieveAPIResults(results: NSDictionary) {
        // Store the results in our table data array
        if results.count > 0 {
            self.albums = []
            let allResults = results["results"] as NSDictionary[]
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result: NSDictionary in allResults {
                var name = result["trackName"] as? String
                if !name? {
                    name = result["collectionName"] as? String
                }
                let artist = result["artistName"] as? String
                // price comes in as formattedPrice or as collectionPrice or as a float
                var price = result["formattedPrice"] as? String
                if !price? {
                    price = result["collectionPrice"] as? String
                    if !price? {
                        var priceFloat = result["collectionPrice"] as? Float
                        var nf = NSNumberFormatter()
                        nf.maximumFractionDigits = 2;
                        price = priceFloat? ? "$"+nf.stringFromNumber(priceFloat) : "No price"
                    }
                }
                let thumbnailURL = result["artworkUrl60"] as? String
                let imageURL = result["artworkUrl100"] as? String
                let optArtistURL = result["artistViewUrl"] as? String
                let artistURL = optArtistURL? ? optArtistURL : "No artist URL"
                var itemURL = result["collectionViewUrl"] as? String
                if !itemURL? {
                    itemURL = result["trackViewUrl"] as? String
                }
                var newAlbum = Album(name: name!, artist: artist!, price: price!,
                    thumbnailImageURL: thumbnailURL!, largeImageURL: imageURL!,
                    itemURL: itemURL!, artistURL: artistURL)
                self.albums.append(newAlbum)
            }
            self.appsTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    // Text Field Delegate Protocol
    
    func textFieldShouldBeginEditing(textField: UITextField!) -> Bool {
        if textField == self.searchTextField {
            self.searchButton.enabled = false
            self.searchTextField.text = nil
        }
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
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.searchItunesFor(searchText)
    }
    
}

