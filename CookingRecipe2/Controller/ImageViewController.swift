//
//  ImageViewController.swift
//  CookingRecipe2
//
//  Created by Mac on 2021/04/09.
//

import UIKit
import SDWebImage
import PKHUD

class ImageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var imageNumber = Int()
    var contents:Contents?
    var userDefaultsEX = UserDefaultsEX()
    
    
    @IBOutlet weak var imageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageTableView.delegate = self
        imageTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        
        imageView.sd_setImage(with: URL(string: (contents?.foodImageUrl)!), completed: nil)
        
        let label1 = cell.contentView.viewWithTag(2) as! UILabel
        
        label1.text = contents?.recipeTitle
        
        let label2 = cell.contentView.viewWithTag(3) as! UILabel
        
        label2.text = contents?.recipeUrl
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 615
    }
    
    
    @IBAction func send(_ sender: Any) {
        
        HUD.show(.progress)
        HUD.dimsBackground = true
        
        let recipemodel:Contents? = userDefaultsEX.codable(forKey: "image")
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
