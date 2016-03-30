//
//  ProfilController.swift
//  SwiftyCompanion
//
//  Created by Soto Yanis on 21/03/2016.
//  Copyright © 2016 Soto Yanis. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift

class ProfilController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    var profilInfo: AnyObject?
    @IBOutlet var profilImage: UIImageView!
    var photoImage :UIImage!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var mailLabel: UILabel!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var mobileLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var levelLabel: UILabel!
    override func viewDidLoad() {
        //print(profilInfo)
        self.activityIndicator.startAnimating()
        dispatch_async(dispatch_get_main_queue())   {
            let image_url = self.profilInfo!["image_url"] as! String
            self.profilImage.imageFromUrl(image_url)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            }
            
        }
        self.progressBar.setProgress(getProgress(), animated: false)
        self.levelLabel.text = getLevel()
        self.mailLabel.text = self.profilInfo!["email"] as? String
        self.loginLabel.text = self.profilInfo!["displayname"] as? String
        self.mobileLabel.text = self.profilInfo!["phone"] as? String
        let locationProfil = self.profilInfo!["location"] as? String
        if locationProfil != nil {
            self.locationLabel.text = locationProfil
        } else {
            self.locationLabel.textAlignment = NSTextAlignment.Center
            self.locationLabel.text = "..."
        }
        
        
        
    }
    
    /* COLLECTION VIEW */
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.profilInfo!["cursus"]!![0]["skills"]!!.count
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("skillCell", forIndexPath: indexPath) as! skillCollectionViewCell
        
        cell.skillTypesLabel.text = String(self.profilInfo!["cursus"]!![0]["skills"]!![indexPath.row]["name"]!!)
        cell.xpLabel.text = String(Float(self.profilInfo!["cursus"]!![0]["skills"]!![indexPath.row]["level"] as! NSNumber)) + " %"
        cell.progressBarLabel.progress = Float(self.profilInfo!["cursus"]!![0]["skills"]!![indexPath.row]["level"] as! NSNumber) * 5 / 100
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    /* TABLE VIEW */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profilInfo!["cursus"]!![0]["projects"]!!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath) as! projectTableViewCell
        
        cell.projectLabel.text = String(self.profilInfo!["cursus"]!![0]["projects"]!![indexPath.row]["name"]!!)
        if (String(self.profilInfo!["cursus"]!![0]["projects"]!![indexPath.row]["name"]!!).lowercaseString != String(self.profilInfo!["cursus"]!![0]["projects"]!![indexPath.row]["slug"]!!).lowercaseString) {
            cell.projectLabel.text = cell.projectLabel.text! + " (" + String(self.profilInfo!["cursus"]!![0]["projects"]!![indexPath.row]["slug"]!!) + ")"
        }
        if (String(self.profilInfo!["cursus"]!![0]["projects"]!![indexPath.row]["final_mark"]!!) == "<null>") {
            cell.noteLabel.text = "in progress"
        } else {
            cell.noteLabel.text = String(self.profilInfo!["cursus"]!![0]["projects"]!![indexPath.row]["final_mark"]!!)
        }
        return cell
    }
    
    func getLevel() -> String {
        let level = self.profilInfo!["cursus"]!![0]["level"]!! as! NSNumber
        var levelString = String(level)
        levelString = levelString.stringByReplacingOccurrencesOfString(".", withString: " - ")
        levelString = "Level \(levelString)%"
        return (levelString)
    }
    
    func getProgress () -> Float {
        let level = self.profilInfo!["cursus"]!![0]["level"]!! as! NSNumber
        return(Float(level) % 1)
    }
    
}

/********* EXTENSION HAVE TO REMOVE FROM THIS FILE ***********/
extension UIImageView {
    public func imageFromUrl(urlString: String) {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if let imageData = data as NSData? {
                    self.image = UIImage(data :imageData)
                }
            }
        })
        dataTask.resume()
    }
}