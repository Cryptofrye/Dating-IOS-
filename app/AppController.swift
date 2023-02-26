//
//  AppController.swift
//
//  Created by Demyanchuk Dmitry on 28.01.17.
//  Copyright © 2017 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class AppController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var authIndicator: UIActivityIndicatorView!    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        iApp.sharedInstance.readSettings();
        
        signUpButton.layer.cornerRadius = 5;
        
        print("id = " + String(iApp.sharedInstance.getId()));
        print("access_token = " + iApp.sharedInstance.getAccessToken());
        print("username = " + iApp.sharedInstance.getUsername());
        print("fullname = " + iApp.sharedInstance.getFullname());
        print("email = " + iApp.sharedInstance.getEmail());
        
        self.showLoadingScreen();
        
        if (iApp.sharedInstance.getId() != 0 && Helper.isInternetAvailable()) {
            
            authorize(accountId: iApp.sharedInstance.getId(), accessToken: iApp.sharedInstance.getAccessToken());
            
        } else {
            
            self.showDefaultScreen();
            
            if (iApp.sharedInstance.getFacebookId().count > 0) {
                
                iApp.sharedInstance.setFacebookId(fbId: "")
                iApp.sharedInstance.setFacebookName(fbName: "")
                iApp.sharedInstance.setFacebookEmail(fbEmail: "")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Hide the navigation bar on the this view controller
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // Show the navigation bar on other view controllers
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func authorize(accountId: Int, accessToken: String) {
        
        self.showLoadingScreen();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_AUTHORIZE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=\(accountId)" + "&accessToken=" + accessToken + "&fcm_regId=" + iApp.sharedInstance.getFcmRegId();
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                self.showDefaultScreen();
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        let accessToken = response["accessToken"] as! String;
                        
                        iApp.sharedInstance.setAccessToken(access_token: accessToken);
                        
                        //Get account array
                        let accountArray = response["account"] as! [AnyObject]
                        
                        //check account state
                        
                        var accountState: Int = 0
                        
                        if (Constants.SERVER_ENGINE_VERSION > 1) {
                            
                            accountState = Int((accountArray[0]["account_state"] as? String)!)!
                            
                        } else {
                            
                            // old server engine
                            
                            accountState = Int((accountArray[0]["state"] as? String)!)!
                        }
                        
                        // if account state ENABLE
                        
                        if (accountState == Constants.ACCOUNT_STATE_ENABLED) {
                            
                            iApp.sharedInstance.authorize(Response: accountArray[0]);
                            
                            DispatchQueue.global(qos: .background).async {
                                
                                DispatchQueue.main.async {
                                    
                                    let storyboard = UIStoryboard(name: "Content", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "TabController")
                                    
                                    // not root navigation controller
                                    
                                    // let navigationController = UINavigationController(rootViewController: vc)
                                    
                                    vc.modalPresentationStyle = .fullScreen
                                    
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.showDefaultScreen();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.showDefaultScreen();
                    }
                }
            }
            
        }).resume()
    }
    
    func showDefaultScreen() {
        
        self.authIndicator.stopAnimating();
        self.authIndicator.isHidden = true;
        
        self.logInButton.isHidden = false;
        self.signUpButton.isHidden = false;
    }
    
    func showLoadingScreen() {
        
        self.authIndicator.startAnimating();
        self.authIndicator.isHidden = false;
        
        self.logInButton.isHidden = true;
        self.signUpButton.isHidden = true;
    }
}

