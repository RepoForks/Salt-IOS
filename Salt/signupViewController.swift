//
//  signupViewController.swift
//  Salt
//
//  Created by AW-MAC on 24/07/17.
//  Copyright © 2017 AW-MAC. All rights reserved.
//

import UIKit
import Alamofire

class signupViewController: UIViewController {

    
    
   
    @IBOutlet weak var txtBxFName: UITextField!
    
    @IBOutlet weak var txtbxLNAme: UITextField!
    
    @IBOutlet weak var txtbxContact: UITextField!
    
    @IBOutlet weak var txtbxEmail: UITextField!
    
    @IBOutlet weak var txtbxPassword: UITextField!
    
    @IBOutlet weak var txtbxConfirm: UITextField!
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnSubmit(_ sender: UIButton) {
    }
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    @IBAction func btnSubmit() {
     //
        
        
        let fname=txtBxFName!.text
        let lname=txtbxLNAme!.text
        let email=txtbxEmail!.text
        let contact=txtbxContact!.text
        let pwd=txtbxPassword!.text
        let cnfpwd=txtbxConfirm!.text
        
        if(pwd != cnfpwd)
        {
            
        }
        
        
        let userDefaults=UserDefaults()
        //print(userDefaults.object(forKey: "TokenID")!)
        
        
        var baseUrl="http://103.90.241.57:3050/api/v1/user/"
        
        var tokenURL="sign_up/"
        var baseUrlToken=baseUrl
        baseUrlToken.append(tokenURL)
        var url=URL(string:"\(baseUrlToken)?")!
        
        let parameter:Parameters=["token":userDefaults.object(forKey: "TokenID")!,"user":["name":fname,"lastname":lname,"email":email,"password":pwd,"contact":contact]]
        
        request(url, method:.post, parameters:parameter, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: {
                repsponse in
                if let result = repsponse.result.value
                {
                    print(result)
                    let json=result as! NSDictionary
                    print(json["msg"]!)
                    //let res:string=string:json["msg"]!
                    self.showToast(message:"\(json["msg"]!)")
                    //let JSON1=result as! NSDictionary
                    
                }
            })

 
        
    }
}

