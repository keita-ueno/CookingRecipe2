//
//  ViewController.swift
//  CookingRecipe2
//
//  Created by Mac on 2021/03/28.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var userName = String()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
       
        jsonAnaly()
        
    }
    
    var contentArray = [Contents]()
    
    
    func jsonAnaly()  {
   
        let url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&applicationId=1014272479943576132"
    
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result{
            
            case .success:
                let json:JSON = JSON(response.data as Any)
                
                for i in 0...json.count{
                        let foodImageUrl = json["result"][i]["foodImageUrl"].string
                        
                        let recipeTitle = json["result"][i]["recipeTitle"].string
                        
            
                        var contentModel = Contents(foodImageUrl:foodImageUrl , recipeTitle:recipeTitle)
                    
                        self.contentArray.append(contentModel)
                }
                
                self.tableView.reloadData()
                
            case .failure(let error):
                
                print(error)
            
                
            }
        }
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contentArray.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let imageView1 = cell.contentView.viewWithTag(1) as! UIImageView
        imageView1.sd_setImage(with: URL(string: contentArray[indexPath.row].foodImageUrl!), completed: nil)
        let recipeTitle = cell.contentView.viewWithTag(2) as! UILabel
        recipeTitle.text = (contentArray[indexPath.row].recipeTitle! as! String)
//
//        let imageView3 = cell.contentView.viewWithTag(3) as! UIImageView
//        imageView3.sd_setImage(with: URL(string: contentArray[indexPath.row].foodImageUrl!), completed: nil)
//
//        let imageView4 = cell.contentView.viewWithTag(4) as! UIImageView
//        imageView4.sd_setImage(with: URL(string: contentArray[indexPath.row].foodImageUrl!), completed: nil)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/2
    }
    
    

}

