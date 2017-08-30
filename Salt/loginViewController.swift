//
//  loginViewController.swift
//  Salt
//
//  Created by AW-MAC on 17/07/17.
//  Copyright © 2017 AW-MAC. All rights reserved.
//

import UIKit
import Alamofire

class loginViewController: UIViewController {

    @IBOutlet weak var txtbxPassword: UITextField!
    @IBOutlet weak var txtbxEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginEvent() {
        //var email=txtbxEmail!.text
        //var password=txtbxPassword!.text
        let baseUrl1=URL(string:"http://103.90.241.57:3050/api/v1/user/generate_auth_token/")!
        
        let parameter=["name":"app"]
        
        request(baseUrl1, method:.post, parameters:parameter, encoding: JSONEncoding.default)
        .responseJSON(completionHandler: {
                repsponse in
            //{
                print(repsponse.result)
                print("HEllo")
           if let result = repsponse.result.value
           {
            let JSON1=result as! NSDictionary
                print(JSON1)
            //let allKeys=JSON.allKeys
            //if JSON1.keys allKeys.contains(where: "token")
            if JSON1["token"] != nil
            {
              print(JSON1["token"]!)
             //   let alertController=UIAlertController(title:"Tokan ID",message:JSON1["token"])
            }
            }
        })
        /*
    //NSURLRequest
      var json= NSMutableDictionary()
        json.setValue("app", forKey: "name")
        var data=JSONSerialization.data(withJSONObject: json, options: //<#T##JSONSerialization.WritingOptions#>)
        */
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
