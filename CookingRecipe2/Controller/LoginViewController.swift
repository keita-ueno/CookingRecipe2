//
//  LoginViewController.swift
//  CookingRecipe2
//
//  Created by Mac on 2021/03/28.
//

import UIKit
import Firebase
import FirebaseAuth
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBAction func tappedRegisterButton(_ sender: Any) {
        handleAuthToFirebase()
    }
    
        private func handleAuthToFirebase(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました。\(err)")
                return
            }
            self.addUserInfoToFirebase(email: email)
        }
    }
    
    private func addUserInfoToFirebase(email: String){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let name = self.userNameTextField.text else {return}
        
        let docData = ["email": email, "name":name, "createdAt": Timestamp()] as [String: Any]
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        
        userRef.setData(docData){ (err) in
            if let err = err {
                print("Firesotreの保存に失敗しました。\(err)")
    
                return
            }
            
            print("Firesotreの保存に成功しました。")
            
            userRef.getDocument { (snapshot, err) in
                if let err = err {
                    print("ユーザー情報の取得に失敗しました。\(err)")
                    return
                }
                
                let data = snapshot? .data()
                
                print("ユーザー情報の取得が出来ました。\(data)")
               
                
                let viewVC = self.storyboard?.instantiateViewController(identifier: "viewVC") as! ViewController
                
                self.navigationController?.pushViewController(viewVC, animated: true)
                
            }
                
        }
        
    }
    
    var provider:OAuthProvider?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = 10
        registerButton.backgroundColor = UIColor.rgb(red: 180, green: 255, blue: 255)

        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyBoard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.provider = OAuthProvider(providerID: TwitterAuthProviderID)
        provider?.customParameters = ["lang":"ja"]
        

        // Do any additional setup after loading the view.
    }
    
    @objc func showKeyBoard(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else { return }
        let registerButtonMaxY = registerButton.frame.maxY
        let distance = registerButtonMaxY - keyboardMinY + 20
        
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = transform
        })
        
        
        
        
        
    }
    
    @objc func hideKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = .identity
        })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func twitterLogin(_ sender: Any) {
        self.provider = OAuthProvider(providerID: TwitterAuthProviderID)
        provider?.customParameters = ["force_login":"true"]
        provider?.getCredentialWith(nil, completion: { (credential, error) in
            
            let activityView = NVActivityIndicatorView(frame: self.view.bounds, type: .ballBeat, color: .magenta, padding: .none)
            self.view.addSubview(activityView)
            activityView.startAnimating()
            
            //ログイン処理
            Auth.auth().signIn(with: credential!) { (result, error) in
                
                if error != nil{
                    
                    return
                    
                }
                
                activityView.stopAnimating()
                
                let viewVC = self.storyboard?.instantiateViewController(identifier: "viewVC") as! ViewController
                viewVC.userName = (result?.user.displayName)!
                self.navigationController?.pushViewController(viewVC, animated: true)
                
            }
            
        })
        
        
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let userNameIsEmpty = userNameTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty || userNameIsEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor.rgb(red: 180, green: 255, blue: 255)
        }else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor.rgb(red: 50, green: 230, blue: 255)
        }
    }
}
