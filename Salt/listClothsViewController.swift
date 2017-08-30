//
//  detailsViewController.swift
//  Salt
//
//  Created by AW-MAC on 31/07/17.
//  Copyright © 2017 AW-MAC. All rights reserved.
//

import UIKit
import Alamofire


class listClothsViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate {
    //@IBOutlet weak var txtFieldName: UITextField!
    //@IBOutlet weak var txtFiledEmail: UITextField!
    //@IBOutlet weak var txtFiledMSg: UITextField!

    var catIDForShow = ""
    var catNameForShow = ""
    
    var reuseindentifire="MyCell"
    var data=[closthDetails]()
    //@IBOutlet weak var imgHeaderImage: UIImageView!
    
    @IBOutlet weak var myCollectionView: UICollectionView!

    override func viewDidLoad() {
            super.viewDidLoad()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(listClothsViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        //getFromUrlAndSet_TokenID()
        self.fetchList(fieldValue: catIDForShow)// "c_02")
        myCollectionView.dataSource=self
        myCollectionView.delegate=self
   
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
  //      var a = "MM"
        self.dismissKeyboard()
       self.sendPostUserSuggestion()
        return true
    }
   
    
    func sendPostUserSuggestion()
     {
        
        let uname = self.footerIndexPath?.txtFieldName.text
        let uemail = self.footerIndexPath?.txtFieldEmail.text
        let umsg = self.footerIndexPath?.txtFieldMsg.text

        
        let userDefaults=UserDefaults()
        var baseUrl=userDefaults.object(forKey: "baseUrl")! as! String
        let tokenURL="user/contactUs/"
        
        baseUrl.append(tokenURL)
        let url=URL(string:"\(baseUrl)?")!
        
        let parameter:Parameters = ["token":userDefaults.object(forKey: "TokenID")!,"user":[ "name":uname,"email":uemail,"subject":"Test", "msg":umsg]]
        
        //let parameter:Parameters = ["token":userDefaults.object(forKey: "TokenID")!,"user":[ "name":"manohar","email":"manohar@algowire.com","subject":"Test", "msg":"From IOS APP"]]
        
        request(url, method:.post, parameters:parameter, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: {
                repsponse in
                print (repsponse)
                if let result = repsponse.result.value
                {
                    let JSON1=result as! NSDictionary
                    if JSON1["msg"] != nil
                    {
                        //var msg1 = JSON1["msg"]
                        
                        self.showToast(message:"\(JSON1["msg"]!)")
                        self.footerIndexPath?.txtFieldName.text = ""
                        self.footerIndexPath?.txtFieldEmail.text = ""
                        self.footerIndexPath?.txtFieldMsg.text = ""
                        

                    }
                }
            })
    }
    
    //
    func getFromUrlAndSet_TokenID()
    
    
    {
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
    }
    //
    
    //
    func fetchList(fieldValue: String) {
        let userDefaults=UserDefaults()
        var baseUrl=userDefaults.object(forKey: "baseUrl")! as! String
        let tokenURL="mimoto/get_field_value/"
        
        let temp = fieldValue.components(separatedBy: "_")
        var fieldName = "Collection"
        
        if ( temp.count>1)
        {
            fieldName = "CategoryId"
        }
        
        let parameter = ["token":userDefaults.object(forKey: "TokenID")!,"corename":"OurStore","fieldname":fieldName,"fieldvalue":fieldValue]
        /*
        if ( catID != "-1")
        {
            
            tokenURL="mimoto/get_product_by_category/"
            
            parameter = ["token":userDefaults.object(forKey: "TokenID")!,"id":catID ]
            
        }
        //var baseUrlToken=baseUrl
        */
        baseUrl.append(tokenURL)
        let url=URL(string:"\(baseUrl)?")!
        
        request(url, method:.post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: {
                repsponse in
                if let result = repsponse.result.value
                {
                    print(result)
                    let json=result as! NSDictionary
                    let blogs = json["allrecords"]! as! NSArray
                    print(blogs)
                    for blog in blogs {
                        let lst1=blog as! NSDictionary
                    print ( lst1)
                        //let temp = closthDetails (Name: lst1["Name"]! as! String, Price: lst1["Price"]! as! NSNumber, ProductId: lst1["ProductId"]! as! String )
                        let images = lst1["Images"]! as! [String]
                       let Features = lst1["Features"] as! NSDictionary
                        let temp = closthDetails(Images: images , Name: lst1["Name"]! as! String, TagLine: lst1["TagLine"]! as! String, Price: lst1["Price"]! as! NSNumber, Description: lst1["Description"]! as! String, Details: lst1["Details"] as! String  ,Fabric: lst1["Fabric"]! as! String, FabricCare: lst1["FabricCare"]! as! String, Fit: Features["Fit"]! as! String, ProductId: lst1["ProductId"]! as! String )
                        
                        self.data.append(temp)// .append(contentsOf: temp)
                        //self.myCollectionView.reloadData()
                    }
                    
                    
                }
                self.myCollectionView.reloadData()
            })
    }
    //

//
    func fetchList_Old(catID: String) {
        let userDefaults=UserDefaults()
        
        var baseUrl=userDefaults.object(forKey: "baseUrl")! as! String
        var tokenURL="mimoto/get_all_categories/"
        var parameter = ["token":userDefaults.object(forKey: "TokenID")!]
        
        if ( catID != "-1")
        {
        
            tokenURL="mimoto/get_product_by_category/"
        
            parameter = ["token":userDefaults.object(forKey: "TokenID")!,"id":catID ]

        }
            //var baseUrlToken=baseUrl
        baseUrl.append(tokenURL)
        let url=URL(string:"\(baseUrl)?")!
        
        request(url, method:.post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: {
                repsponse in
                if let result = repsponse.result.value
                {
                    print(result)
                    let json=result as! NSDictionary
                    //if ( json["status"] = "200" )
                    //{
                    let blogs = json["allProducts"]! as! NSArray
                     //let blogsa = blogs
                    print(blogs)
                    for blog in blogs {
                        let lst1=blog as! NSDictionary
                        //print( lst1["Name"]! )
                        //print( lst1["Price"]!)
                        //print ( lst1["ProductId"]!)
                        
                        //closthDetails tmp
                       /*
                        let temp = closthDetails (Name: lst1["Name"]! as! String, Price: lst1["Price"]! as! NSNumber, ProductId: lst1["ProductId"]! as! String )
                        self.data.append(temp)
                        */
                    }
                    
                    
                }
                self.myCollectionView.reloadData()
            })
    }
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //var data = ["HEllo","aarti","pooja","dev"]
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print ( self.data.count )
        return self.data.count - 1
    }
    /*
    func setImageFromURL(stringImgUrl url:String)  {
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url) {
                cell.imgClothImage.image = UIImage(data: data)
            }
        }
    }*/
    
   func collectionView(_ collectionView:   UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! listClothesCollectionViewCell
        cell.lblClothName?.text  = self.data[ indexPath.row ].Name
    var priceINR:String = "\u{20B9}";
    priceINR.append(String(describing: self.data[ indexPath.row].Price as NSNumber))
    cell.lblClothPrice?.text = priceINR // String(describing: self.data[ indexPath.row + 1 ].Price as NSNumber)// . as! String
    
    // 
    /*
    long row=[indexPath row];
    NSString *catImagePath=[NSString stringWithFormat:@"%@",[self.recipeImge[row] objectForKey:@"ImageUrl"]];
    NSString *recipeName=[NSString stringWithFormat:@"%@",[ recipeImge[row] objectForKey:@"ItemName"]];
    img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:catImagePath]]];
    NSString *recipeFullPrice=@"\u20B9";
    recipeFullPrice=[recipeFullPrice stringByAppendingString:[NSString stringWithFormat:@"%@",[ recipeImge[row] objectForKey:@"ItemFullPrice"]]];
    cell.imgRecipe.image=img;
*/
    //
    var imgURL = "http://103.90.241.57:84/assets/"
    imgURL.append(self.data[indexPath.row].ProductId )
    imgURL.append("/thumb.jpg")
    
    //
    if let url = NSURL(string: imgURL) {
        if let data = NSData(contentsOf: url as URL) {
           cell.imgClothImage.image = UIImage(data: data as Data)
            
            
        }
    }
    //
    
    

    
    
        return cell
    }
    
    var footerIndexPath:clothsCollectionReusableView? = nil
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerId = "MyHeader"
        if ( kind.contains("Footer") )
        {
        headerId = "MyFooter"
            //footerIndexPath = indexPath
        }
        let headerView = myCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! clothsCollectionReusableView
        
        //
        if ( kind.contains("Header") )
        {
        if ( self.data.count > 0 )
        {
            var imagePath="videos/"
            while ( true )
            {
                var imgURL = "http://103.90.241.57:84/assets/"
                //var imagePath="videos/"
                imgURL.append(imagePath)
                imgURL.append(catNameForShow)
                imgURL.append(".jpg")
        
        //
                if let url = NSURL(string: imgURL) {
                    if let data = NSData(contentsOf: url as URL) {
                        headerView.imgHeaderImage.image = UIImage(data: data as Data)
                        if UIImage(data: data as Data) != nil
                        {
                        break
                        }
                        else
                        {
                            imagePath = "images/"        
                        }
                
                    }
                    else
                    {
                    imagePath = "images/"
                    }
                    
                }
                }
            
        }
        }
        
        else//footerView
        {
        footerIndexPath = headerView
        }
        
        //
        
        
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = myCollectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.gray
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = myCollectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
        
        let ab = self.data[indexPath.row]
        self.showToast(message: ab.Name)
        
        //
        let myVC1 = storyboard?.instantiateViewController(withIdentifier:"DetailsViewSB") as! detailsClothViewController
        myVC1.Images = ab.Images
        myVC1.clothName = ab.Name
        myVC1.TagLine = ab.TagLine
        myVC1.Price = Int(ab.Price)
        
        myVC1.Description = ab.Description
        myVC1.Details = ab.Details
        myVC1.Fabric = ab.Fabric
        myVC1.FabricCare = ab.FabricCare
        myVC1.Fit = ab.Fit
        
        navigationController?.pushViewController(myVC1, animated: true)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ab = self.data[indexPath.row]
        self.showToast(message: ab.Name)
        
        //
        let myVC1 = storyboard?.instantiateViewController(withIdentifier:"DetailsViewSB") as! detailsClothViewController
        myVC1.Images = ab.Images
        myVC1.clothName = ab.Name
        myVC1.TagLine = ab.TagLine
        myVC1.Price = Int(ab.Price)

        myVC1.Description = ab.Description
        myVC1.Details = ab.Details
        myVC1.Fabric = ab.Fabric
        myVC1.FabricCare = ab.FabricCare
        myVC1.Fit = ab.Fit
        
        navigationController?.pushViewController(myVC1, animated: true)
        //
        
        //var viewController =
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height-100, width: self.view.frame.size.width, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 1;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    var myList=["Hh","gg","Bb"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
        
        //let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: <#T##IndexPath#>)
        
        //cell.textLabel?.text=mylist[IndexPath.row]
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = myList[indexPath.row]
        return cell
    }
 */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
struct closthDetails
{
    var Images = [String]()
    var Name:String = "Nil"
    var TagLine:String = "Nil"
    var Price:NSNumber = -1
    var Description:String = "Nil"
    var Details:String = "Nil"
    var Fabric:String = "Nil"
    var FabricCare = "Nil"
    var Fit:String = "Nil"
    var ProductId:String = "Nil"
    
    
}
