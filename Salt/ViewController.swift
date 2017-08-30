//
//  ViewController.swift
//  Salt
//
//  Created by AW-MAC on 17/07/17.
//  Copyright © 2017 AW-MAC. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //
       // let baseUrl="http://103.90.241.57:3050/api/v1/"
        
       // let userDefaults=UserDefaults()
        //userDefaults.set(baseUrl, forKey: "baseUrl")
        
        //
        
        //getFromUrlAndSet_TokenID()
        /*
        let userDefaults=UserDefaults()
        userDefaults.set("abc", forKey: "TokenID")
        print(userDefaults.object(forKey: "TokenID")!)
        
        let baseUrl1=URL(string:"http://103.90.241.57:3050/api/v1/user/generate_auth_token/")!
        
        let parameter=["name":"app"]
        
        request(baseUrl1, method:.post, parameters:parameter, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: {
                repsponse in
                if let result = repsponse.result.value
                {
                    let JSON1=result as! NSDictionary
                    if JSON1["token"] != nil
                    {
                      userDefaults.set(JSON1["token"]!, forKey: "TokenID")
                    }
                }
            })
        */
    
    //
        
    }

    
    //
    func getFromUrlAndSet_TokenID()
    {
        let userDefaults=UserDefaults()
        //userDefaults.set("abc", forKey: "TokenID")
        //print(userDefaults.object(forKey: "TokenID")!)
        
        
        
       // let baseUrl1=URL(string:"http://103.90.241.57:3050/api/v1/user/generate_auth_token/")!
        
        
        //
        var baseUrl = userDefaults.object(forKey: "baseUrl")! as! String
        let tokenURL="user/generate_auth_token/"
        
        //var baseUrlToken=baseUrl
        baseUrl.append(tokenURL)
        let url=URL(string:"\(baseUrl)?")!

        //
        
        
        let parameter=["name":"app"]
        
        request(url, method:.post, parameters:parameter, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: {
                repsponse in
                if let result = repsponse.result.value
                {
                    let JSON1=result as! NSDictionary
                    if JSON1["token"] != nil
                    {
                        userDefaults.set(JSON1["token"]!, forKey: "TokenID")
                    }
                }
            })
    }
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

