//
//  LoginViewController.swift
//  Umojify
//
//  Created by Jacob Silverstein on 8/5/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

import UIKit
import AVFoundation

class LoginViewController: UIViewController {

    @IBOutlet var loginView: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    var gender = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpFacebookLoginButton()
        
        
        //Setup Login Button
        continueButton.setTitleColor(UIColor.white, for: UIControlState())
        continueButton.layer.borderWidth = 2
        continueButton.layer.borderColor = UIColor.white.cgColor
        continueButton.layer.cornerRadius = 4
        
        logOutButton.tintColor = UIColor.white
        
        loginView.backgroundColor = UIColor(red: 41.0/255.0, green: 182/255.0, blue: 246/255.0, alpha: 1.0)
        loginView.layer.cornerRadius = 4
        loginView.layer.borderWidth = 2
        loginView.layer.borderColor = UIColor.white.cgColor
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.barStyle = UIBarStyle.black

        
        
        
        
        //Setup Gradient
        let colorLeft = UIColor(red: 12.0/255.0, green: 178.0/255.0, blue: 240.0/255.0, alpha: 1.0).cgColor
        let colorRight = UIColor(red: 88.0/255.0, green: 55.0/255.0, blue: 172.0/255.0, alpha: 1.0).cgColor
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [colorLeft, colorRight]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
        

        
        
    }
    
    @IBAction func logOut(_ sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        setUpFacebookLoginButton()
        gender = 2

    }
    
    func setUpFacebookLoginButton() {
        if (FBSDKAccessToken.current() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("alreadyLoggedin")
            returnUserData()
            loginView.isEnabled = false
            loginView.alpha = 0
            logOutButton.isEnabled = true
            logOutButton.alpha = 1
            continueButton.setTitle("Press to Continue", for: UIControlState())
        }
        else
        {
            loginView.isEnabled = true
            loginView.alpha = 1
            logOutButton.isEnabled = false
            logOutButton.alpha = 0
            self.view.addSubview(loginView)
            continueButton.setTitle("Skip Sign Up For Now", for: UIControlState())


        }
    }
    
    @IBAction func fbLoginPressed(_ sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        //fbLoginManager.loginBehavior = FBSDKLoginBehavior.Browser
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile"], from: self, handler: { (result, error) -> Void in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    self.setUpFacebookLoginButton()
                    //fbLoginManager.logOut()
                }
            }
        })
    }
    
    @IBAction func continueButtonPressed(_ sender: AnyObject) {
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "CameraPrepViewController") as! CameraPrepViewController
        vc.gender = self.gender
        self.navigationController?.pushViewController(vc, animated:true)

        
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, gender"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                let res = result as AnyObject?
                let gen = ((res?.object(forKey: "gender") as AnyObject))
                print("fetched user: \(result)")
                if gen.isEqual("male") {
                    self.gender = 0
                } else if gen.isEqual("female") {
                    self.gender = 1
                }
                
                /*
                if (((res?.object(forKey: "gender") as AnyObject).isEqual(to: "male")) != nil) {
                    self.gender = 0
                } else if ((res.object(forKey: "gender")?.isEqual(to: "female")) != nil) {
                    self.gender = 1
                }
                */
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
