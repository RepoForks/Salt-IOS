//
//  detailsClothViewController.swift
//  Salt
//
//  Created by AW-MAC on 08/08/17.
//  Copyright © 2017 AW-MAC. All rights reserved.
//

import UIKit

class detailsClothViewController: UIViewController {

    
    var clothName = ""
    var Images = [String]()
    var TagLine = ""
    var Price = 0
    var Description = ""
    var Details = ""
    var Fabric = "Nil"
    var FabricCare = "Nil"
    var Fit = "Nil"
    var imgPageControlCounter = 0
    @IBOutlet weak var lblClothName: UILabel!
    @IBOutlet weak var imgClothImage: UIImageView!
    @IBOutlet weak var lblTagLine: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var myPageCtrl: UIPageControl!

    var myTimer:Timer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.myPageCtrl.numberOfPages = self.Images.count
        self.myPageCtrl.currentPage = 0
        // Do any additional setup after loading the view.
        lblClothName.text = self.clothName
        if let url = NSURL(string: self.Images[0])
        {
            if let data = NSData(contentsOf: url as URL) {
                imgClothImage.image = UIImage(data: data as Data)
                /*
                if UIImage(data: data as Data) != nil
                {
                    let nn = "No Images"
                    //imgClothImage.image?.description = nn
                }*/
            }
        }
        lblTagLine?.text = self.TagLine
        var priceINR:String = "\u{20B9}";
        priceINR.append(String(self.Price))
        lblPrice?.text = priceINR
        lblDescription?.text = self.Description
        
        //var myTimer:Timer!
           myTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.handlerTimer), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let myTimer = myTimer
        {
            myTimer.invalidate()
        }
    }
    @IBAction func myPageControlAction(_ sender: UIPageControl) {
        
        imgPageControlCounter = self.myPageCtrl.currentPage
        let banImagePath = self.Images[imgPageControlCounter]
        if let url = NSURL(string: banImagePath)
        {
            if let data = NSData(contentsOf: url as URL) {
                imgClothImage.image = UIImage(data: data as Data)
            }
        }

    }

    func handlerTimer()
    {
    
        imgPageControlCounter = imgPageControlCounter + 1
        if(imgPageControlCounter>=self.myPageCtrl.numberOfPages)
        {
            imgPageControlCounter=0;
            
        }
        self.myPageCtrl.currentPage = imgPageControlCounter
        let banImagePath = self.Images[imgPageControlCounter]
        if let url = NSURL(string: banImagePath)
        {
            if let data = NSData(contentsOf: url as URL) {
                imgClothImage.image = UIImage(data: data as Data)
            }
        }
    
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

}
