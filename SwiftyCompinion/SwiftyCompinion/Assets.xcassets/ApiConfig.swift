//
//  ApiConfig.swift
//  SwiftyCompinion
//
//  Created by Soto Yanis on 25/01/2016.
//  Copyright © 2016 Soto Yanis. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift


//oauth/token/info

enum ApiStatus {
    case Undefined
    case Granted
    case Denied
}

class ApiConfig: NSObject {
    
    let params = [
        "grant_type" : "client_credentials",
        "client_id": "1f277e201b57fcb20e0657f0ba6ce78bfcee859c0c15b177233d198485ec9d38",
        "client_secret": "0f8b56449e8b6d305b92e49f0bab9ab1514f749e44e49da7b7978e0721628f74"
        
    ]
    let keychain = KeychainSwift()

    /* Core Function */
    
    func TryAuth (completion: () -> Void) {
        Alamofire.request(.POST, "https://api.intra.42.fr/oauth/token", parameters: params)
            .responseJSON { response in
            switch response.result {
                case .Success(let JSON):
                if let token = JSON["access_token"] as? String {
                    self.saveToken(token)
                    // print ("Success with JSON: \(JSON)")
                    completion()
                }
                case .Failure(let error):
                    print ("Request failed with error: \(error)")
                    completion()
            }
        }
    }

    func checkToken (completion: Bool -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.intra.42.fr/oauth/token/info")!)
        request.HTTPMethod = "GET"
        request.setValue("Bearer \(self.loadToken())", forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    //print ("Success with JSON: \(JSON)")
                    if let error = JSON["error"] as! String? {
                        if error == "invalid_request" { return (completion(false)) }
                        else { return (completion(true)) }
                    }
                    completion(true)
                case .Failure(let error):
                    print ("Request failed with error: \(error)")
                    return completion(false)
            }
        }
    }
    
    func getUser(user: String, completion: ((isReponse: AnyObject) -> Void)) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.intra.42.fr/v2/users/\(user)")!)
        request.HTTPMethod = "GET"
        request.setValue("Bearer \(self.loadToken())", forHTTPHeaderField: "Authorization")

        Alamofire.request(request)
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    completion(isReponse: JSON)
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
    }
    
    
    /* KeyChain fuction */
    
    func saveToken (token: String) {
        keychain.set(token, forKey: "token")
    }
    
    func loadToken () -> String{
        
        let token = keychain.get("token")
        return token!
    }
}
