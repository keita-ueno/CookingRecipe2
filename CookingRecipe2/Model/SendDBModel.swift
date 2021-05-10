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
    
    func sendimageView1Data(imageData:Data,recipeTitle:String){
        
        HUD.show(.progress)
        
        let imageRef = Storage.storage().reference().child("recipedata").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        imageRef.putData(imageData, metadata: nil) { (matadata, error) in
            
            if error != nil{
                return
            }
            imageRef.downloadURL { (url, error) in
                
                if url != nil {
                    
                    let imageModel = Contents(foodImageUrl: url?.absoluteString, recipeTitle: recipeTitle)
                    
                    
                    //アプリ内に画像とレシピを保存
                    self.userDefaultsEX.set(value: imageModel, forKey: "image")
                    
                    
                    
                    //データを送信
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownContents").document().setData(["image":url?.absoluteString,"recipeTitle":recipeTitle,"Date":Date().timeIntervalSince1970])
                    
                }
                
                print(url?.debugDescription)
                
                
                
                self.sendImageDone?.checkOK()
                
                
            }
            
        }
        
    }
    
}
