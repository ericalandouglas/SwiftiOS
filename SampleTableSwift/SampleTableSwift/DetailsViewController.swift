//
//  DetailsViewController.swift
//  SampleTableSwift
//
//  Created by Eric Douglas on 6/9/14.
//  Copyright (c) 2014 Dougie's Apps. All rights reserved.
//

import UIKit
import MediaPlayer
import QuartzCore

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIControllerProtocol {
    
    @IBOutlet var albumCover: UIImageView
    @IBOutlet var titleLabel: UILabel
    @IBOutlet var tracksTableView : UITableView
    var album: Album?
    var tracks = Track[]()
    var indexOfTrackPlaying : NSIndexPath?
    let mediaPlayer = MPMoviePlayerController()
    @lazy var api: APIController = APIController(delegate: self)
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.album?.title
        self.albumCover.image = UIImage(data: NSData(contentsOfURL:
            NSURL(string: self.album?.largeImageURL)))
        if self.album?.collectionId? {
            self.api.lookupAlbum(self.album!.collectionId!)
        }
    }
    
    // Table View Protocols
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as TrackCell
        let track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playIcon.text = "🔊"
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var track = tracks[indexPath.row]
        var indexPathThatWasPlaying : NSIndexPath?
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            if trackPlaying(indexPath) {
                cell.playIcon.text = "🔊"
                self.stopPlayingTrack()
            } else {
                cell.playIcon.text = "🔇"
                indexPathThatWasPlaying = stopPlayingTrack()
                self.mediaPlayer.contentURL = NSURL(string: track.previewUrl)
                self.mediaPlayer.play()
                self.indexOfTrackPlaying = indexPath
            }
            if indexPathThatWasPlaying? {
                tableView.reloadRowsAtIndexPaths([indexPathThatWasPlaying!], withRowAnimation: UITableViewRowAnimation.None)
            }
        }
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    // Media Playback Helpers
    
    func stopPlayingTrack() -> NSIndexPath? {
        self.mediaPlayer.stop()
        let indexPathThatWasPlaying = self.indexOfTrackPlaying
        self.indexOfTrackPlaying = nil
        return indexPathThatWasPlaying
    }
    
    func trackPlaying(indexPath: NSIndexPath) -> Bool {
        return self.indexOfTrackPlaying? && (self.indexOfTrackPlaying! == indexPath)
    }
    
    // API Protocol
    
    func didRecieveAPIResults(results: NSDictionary) {
        if let allResults = results["results"] as? NSDictionary[] {
            for trackInfo in allResults {
                // Create the track
                if let kind = trackInfo["kind"] as? String {
                    if kind == "song" {
                        let track = Track(dict: trackInfo)
                        self.tracks.append(track)
                    }
                }
            }
        }
        self.tracksTableView.reloadData()
    }
    
}
