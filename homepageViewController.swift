//
//  homepageViewController.swift
//  Salt
//
//  Created by AW-MAC on 25/07/17.
//  Copyright © 2017 AW-MAC. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire


class homepageViewController: UIViewController {
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    var myStackViewForCommand:UIStackView?
    
    
    @IBOutlet weak var stkvwCommandList: UIStackView!
    @IBOutlet weak var imgHome: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //
        let singlwFingerTap=UITapGestureRecognizer(target: self, action: #selector(cmdSHOP1))
        self.view.addGestureRecognizer(singlwFingerTap)
        
        //
        
        /*
        //code for GIF player
        let filePath = Bundle.main.path(forResource: "giphy", ofType: "gif")
        let gif = NSData(contentsOfFile: filePath!)
        let webViewBG = UIWebView(frame: self.imgHome.frame)// .view.frame)
        webViewBG.load(gif! as Data, mimeType: "image/gif", textEncodingName: "UTF-8", baseURL: NSURL(string: "")! as URL)
        webViewBG.isUserInteractionEnabled = false
        webViewBG.layer.zPosition = -2.0
        self.view.addSubview(webViewBG)
        //
        */
        // Do any additional setup after loading the view.
        
        let theURL = Bundle.main.url(forResource:"Home.Mobile", withExtension: "mp4")
        
        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
 
 
         }
    
    func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
        paused = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
     @IBAction func showMimotoCmdList(_ sender: Any) {
        
        /*
        if( myStackViewForCommand != nil)
        {
            myStackViewForCommand?.removeFromSuperview()
            return
        }
        */
        let userDefaults=UserDefaults()
        //print(userDefaults.object(forKey: "TokenID")!)
        
        
        let baseUrl="http://103.90.241.57:3050/api/v1/"
        
        let tokenURL="mimoto/get_all_collection/"
        var baseUrlToken=baseUrl
        baseUrlToken.append(tokenURL)
        let url=URL(string:"\(baseUrlToken)?")!
        
        let parameter = ["token":userDefaults.object(forKey: "TokenID")!,"mimoto":["source":"app" ] ]
        //"user":["name":fname,"lastname":lname,"email":email,"password":pwd,"contact":contact]]
        
        request(url, method:.post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: {
                repsponse in
                if let result = repsponse.result.value
                {
                    print(result)
                    let json=result as! NSDictionary
                    //if ( json["status"] = "200" )
                    //{
                    let blogs = json["data"]! as! NSArray
                    // let blogsa = blogs
                    var viewArray1=[UIView]()
                    viewArray1 += [self.stepperButtonText(text: "Mimoto", action: #selector(self.cmdSHOP1))]
                    for blog in blogs {
                        let lst1=blog as! NSDictionary
                        //print( lst1["ID"]! )
                        //print( lst1["Collection"]!)
                        //let abc:String  = lst1["Collection"]! as! String
                        
                        //
                        let CollectionName:String  = lst1["Collection"]! as! String
                        //let CollectionID:String  = lst1["ID"]! as! String
                        
                        self.dictAllClothInfo.updateValue(CollectionName, forKey: CollectionName.lowercased())
                        //
                        
                        viewArray1 += [self.stepperButtonText(text: CollectionName.uppercased(), action: #selector(self.goDeatilsViewSB))]
                        
                    }
                    self.showCommandList(viewArray1:viewArray1)
                    
                }
            })
     }
    @IBAction func btnDiscoverAction(_ sender: UIButton) {
        
        /*
        if( myStackViewForCommand != nil)
        {
            myStackViewForCommand?.removeFromSuperview()
            return
        }
        */
        var viewArray1=[UIView]()
        viewArray1 += [self.stepperButtonText(text: "Discover Salt", action: #selector(self.cmdSHOP1))]
        viewArray1 += [self.stepperButtonText(text: "OUR STORY", action: #selector(self.cmdSHOP1))]
        viewArray1 += [self.stepperButtonText(text: "OUR DESIGN", action: #selector(self.cmdSHOP1))]
        
        viewArray1 += [self.stepperButtonText(text: "FABRIC", action: #selector(self.cmdSHOP1))]
        viewArray1 += [self.stepperButtonText(text: "SIZE & FIT", action: #selector(self.cmdSHOP1))]
        viewArray1 += [self.stepperButtonText(text: "FINISHING & DETAILS", action: #selector(self.cmdSHOP1))]
        viewArray1 += [self.stepperButtonText(text: "WHY SALT?", action: #selector(self.cmdSHOP1))]
        
    self.showCommandList(viewArray1:viewArray1)
    }
    
    @IBAction func btnContactUs(_ sender: UIButton) {
        if( myStackViewForCommand != nil)
        {
            myStackViewForCommand?.removeFromSuperview()
            return
        }
    }
    var dictAllClothInfo = [String:String]()
    @IBAction func goDeatilsViewSB(_ sender: UIButton) {
        
        let txt = sender.titleLabel?.text?.lowercased()//  as! UIButton
            //txt.titleLabel?.text.currenTitle!
        myStackViewForCommand?.removeFromSuperview()
        let myVC = storyboard?.instantiateViewController(withIdentifier:"ListViewSB") as! listClothsViewController
        myVC.catIDForShow = self.dictAllClothInfo[txt!]!//   "c_02"
        myVC.catNameForShow = txt!// "skirts"
        navigationController?.pushViewController(myVC, animated: true)
        //myStackViewForCommand?.removeFromSuperview()
    }
    
    @IBAction func cmdSHOP1(_ sender: UIButton) {
                
        myStackViewForCommand?.removeFromSuperview()
 }
    @IBAction func cmdShop(_ sender: UIButton)
    {
        
            let userDefaults=UserDefaults()
        
        
        
        let baseUrl="http://103.90.241.57:3050/api/v1/"
        
        let tokenURL="mimoto/get_all_categories/"
        var baseUrlToken=baseUrl
        baseUrlToken.append(tokenURL)
        let url=URL(string:"\(baseUrlToken)?")!
        
        let parameter = ["token":userDefaults.object(forKey: "TokenID")!]
        //"user":["name":fname,"lastname":lname,"email":email,"password":pwd,"contact":contact]]
        
        request(url, method:.post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: {
                repsponse in
                if let result = repsponse.result.value
                {
                    //print(result)
                    let json=result as! NSDictionary
                    //if ( json["status"] = "200" )
                    //{
                    let blogs = json["allCategories"]! as! NSArray
                   // let blogsa = blogs
                    var viewArray1=[UIView]()
                    viewArray1 += [self.stepperButtonText(text: "Shop", action: #selector(self.goDeatilsViewSB))]
                    
                     for blog in blogs {
                    let lst1=blog as! NSDictionary
                        //print( lst1["ID"]! )
                        //print( lst1["Category"]!)
                        let categoryName:String  = lst1["Category"]! as! String
                        let catID:String  = lst1["ID"]! as! String

                        self.dictAllClothInfo.updateValue(catID, forKey: categoryName.lowercased())
                        //print( self.dictAllClothInfo.count )
                        //print ( self.dictAllClothInfo )//[categoryName] )
                        viewArray1 += [self.stepperButtonText(text: categoryName.uppercased(), action: #selector(self.goDeatilsViewSB))]
                        
                    }
                    self.showCommandList(viewArray1:viewArray1)
                    
                }
            })

    
    }
    func showCommandList(viewArray1:[UIView])//-> <#return type#> {
        
    //}
    {
        self.view.backgroundColor=UIColor(white:1,alpha:0.5)
        
        //var viewArray1=[UIView]() //[UIView]//()
        //viewArray1 = [stepperButtonText(text: "Add", action: #selector(cmdShop))]
        //viewArray1 += [stepperButtonText(text: "DispHellllllllll", action: #selector(cmdShop))]
        //viewArray1 += [stepperButtonText(text: "Del", action: #selector(cmdShop))]
        let stackView = UIStackView(arrangedSubviews: viewArray1)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually//.equalSpacing//  .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        if( myStackViewForCommand != nil )
        {
            myStackViewForCommand?.removeFromSuperview()
        }
        myStackViewForCommand=stackView
        
        let viewsDictionary = ["stackView":stackView]
        
        let stackView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[stackView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        
        let stackView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-150-[stackView]-150-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        
        view.addConstraints(stackView_H)
        view.addConstraints(stackView_V)
        
    }
    /*
     {
     
     //var viewArray1=[UIView]() //[UIView]//()
     viewArray1 = [stepperButtonText(text: "Add", action: #selector(cmdShop))]
     viewArray1 += [stepperButtonText(text: "DispHellllllllll", action: #selector(cmdShop))]
     viewArray1 += [stepperButtonText(text: "Del", action: #selector(cmdShop))]
     let stackView = UIStackView(arrangedSubviews: viewArray1)
     
     //stackView.frame.origin.x = view.frame.width/2 - stackView.frame.width/2
     //stackView.frame.origin.y = view.frame.height/2 - stackView.frame.width/2
     //let stackView = UIStackView(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
     //stackView.alignmentRect ( forFrame: CGRect(x: 100, y: 100, width: 100, height: 100))
     stackView.axis = .vertical
     stackView.distribution = .fillEqually//.equalSpacing//  .fillEqually
     stackView.alignment = .fill
     //stackView.spacing = 5
     stackView.translatesAutoresizingMaskIntoConstraints = false
     //self.view.addSubview(stackView)
     //myStackViewForCommand=stackView
     
     //let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
     //button.backgroundColor = UIColor.green
     //button.setTitle("Test Button", for: .normal)
     //button.addTarget(self, action: #selector(cmdShop), for: .touchUpInside)
     
     //self.view.addSubview(button)
     self.stkvwCommandList=UIStackView()
     self.view.addSubview(stkvwCommandList)
     //self.stkvwCommandList.isHidden=false
     var viewArray=UIView() //[UIView]//()
     viewArray = stepperButtonText(text: "Add1", action: #selector(cmdShop))
     //viewArray += [stepperButtonText(text: "DispHellllllllll", action: #selector(cmdShop))]
     //viewArray+=[stepperButtonText(text: "Del", action: #selector(nil))]
     //let stackview=UIStackView(arrangedSubviews: viewArray)
     //stackview.alignment = .fill
     //stackview.distribution = .fillEqually
     //stackview.axis = .horizontal
     //stackview.spacing = 1.0
     //self .view.addSubview(stackview)
     //self.stackView.addArrangedSubview(viewArray)
     //self.stkvwCommandList.removeArrangedSubview(viewArray)
     //self.stkvwCommandList.superview?.addSubview(viewArray)
     //self.stkvwCommandList.removeFromSuperview()
     
     viewArray = stepperButtonText(text: "Delete", action: #selector(cmdShop))
     stackView.addArrangedSubview(viewArray)
     //self.stkvwCommandList.superview?.addSubview(viewArray)
     
     viewArray = stepperButtonText(text: "DDisp1", action: #selector(cmdShop))
     stackView.addArrangedSubview(viewArray)
     //self.stkvwCommandList.superview?.addSubview(viewArray)
     self.view.addSubview(stackView)
     if( myStackViewForCommand != nil )
     {
     myStackViewForCommand?.removeFromSuperview()
     }
     myStackViewForCommand=stackView
     
     let viewsDictionary = ["stackView":stackView]
     /*
     let stackView_H = NSLayoutConstraint.constraintsWithVisualFormat(
     "H:|-20-[stackView]-20-|",  //horizontal constraint 20 points from left and right side
     options: NSLayoutFormatOptions(rawValue: 0),
     metrics: nil,
     views: viewsDictionary)*/
     let stackView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-1-[stackView]-1-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
     
     let stackView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-150-[stackView]-150-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
     //.constraintsWithVisualFormat(
     //"V:|-30-[stackView]-30-|", //vertical constraint 30 points from top and bottom
     //options: NSLayoutFormatOptions(rawValue:0),
     //metrics: nil,
     //views: viewsDictionary)
     view.addConstraints(stackView_H)
     view.addConstraints(stackView_V)
     
     }
    */
    func stepperButtonText(text:String,action:Selector)->UIButton
    {
        //let button=UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 5))
        let button=UIButton()
        //button.
        button.backgroundColor = UIColor(white:1,alpha:0.6)//black//(UIColor.black)//  UIColor(alpha ( ) .black
        //button.set
        button.setTitle(text, for:.normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }

}
