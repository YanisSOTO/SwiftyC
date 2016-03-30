//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by Soto Yanis on 21/03/2016.
//  Copyright © 2016 Soto Yanis. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift

class ViewController: UIViewController {
    let api = ApiConfig()
    var profilInfo: AnyObject?


    @IBOutlet var textField: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*Start check/init our case Token */
        if (KeychainSwift().get("token") == nil) {
            KeychainSwift().set("default", forKey: "token")
        }
        
        api.checkToken() { response in
            if (response.boolValue == true) {
                print("connected")
            }
            else {
                print("tryAuth")
                self.api.TryAuth()
            }
        }
    }

    @IBAction func searchAction(sender: UIButton) {
        
        if (self.textField.text == "") {
            print("empty textfield")
        }
        else if ((self.textField.text?.isEmpty) != nil) {
            self.api.getUser(self.textField.text!) { response in
                if (response.count == 0) {
                    let alert = UIAlertController(title: "Error", message: "This username doesn't exist", preferredStyle:  UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else {
                    self.profilInfo = response
                    self.performSegueWithIdentifier("showProfil", sender: self)
                }
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showProfil") {
            let svc = segue.destinationViewController as? ProfilController
            svc?.profilInfo = self.profilInfo
        }
    }
    
    
    
    /************************************************************/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

