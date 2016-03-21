//
//  ViewController.swift
//  SwiftyCompinion
//
//  Created by Soto Yanis on 21/01/2016.
//  Copyright © 2016 Soto Yanis. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    let api = ApiConfig()
    var profilInfo: AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Change return by done, and turn the keyboard off when pressing it
        textField.returnKeyType = UIReturnKeyType.Done
        //self.textField.delegate = self
        self.errorLabel.hidden = true
        
        //Just checking if the  field "token" exist in the keychain
        if (KeychainSwift().get("token") == nil) {
            KeychainSwift().set("default", forKey: "token")
        }
        
        // Check if our token is already good, if not we try to get a new one.
        api.checkToken() { response in
            if response.boolValue == true {
                print ("Connected")
            }
            else {
                print ("tryAuth")
                self.api.TryAuth(){ print(KeychainSwift().get("token")) }
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Resarch bar */
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func trySearch(sender: UIButton) {
        self.api.getUser(self.textField.text!) { isResponse in
            if (isResponse.count == 0) {
                print("here")
                self.errorLabel.hidden = false

                //let alert = UIAlertController(title: "Error", message: "This username doesn't exist", preferredStyle: UIAlertControllerStyle.Alert)
                //alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                //self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                self.errorLabel.hidden = true
                self.profilInfo = isResponse
                self.performSegueWithIdentifier("showProfil", sender: self)
            }
        }

    }

    /* Segue */
    
  /*  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showProfil") {
            let svc = segue.destinationViewController as? ProfilController
            svc?.profilInfo = self.profilInfo
        }
    } */
}

