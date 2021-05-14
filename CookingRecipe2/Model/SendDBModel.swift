//
//  SendDBModel.swift
//  CookingRecipe2
//
//  Created by Mac on 2021/04/23.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseAuth
import FirebaseStorage
import PKHUD

protocol SendImageDone {
    
    func checkOK()
}

class SendDBModel {
    
    let db = Firestore.firestore()
    var sendImageDone:SendImageDone?
    var userDefaultsEX = UserDefaultsEX()
    
    init() {
            
    }
    
    func sendimageView1Data(imageString:String,recipeTitle:String){
        
        HUD.show(.progress)
        
        //アプリ内に画像とレシピを保存
//        self.userDefaultsEX.set(value: imageModel, forKey: "image")
        
        //データを送信
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownContents").document().setData(["image":imageString,"recipeTitle":recipeTitle,"Date":Date().timeIntervalSince1970])
        
        
    
    
    
    self.sendImageDone?.checkOK()
        
    }

}
