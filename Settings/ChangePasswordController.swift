//
//  ChangePasswordController.swift
//  SocialApp
//
//  Created by Mac Book on 25.01.17.
//  Copyright © 2017 Ifsoft. All rights reserved.
//

import UIKit

class ChangePasswordController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var currentPasswordSeparator: UIView!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordSeparator: UIView!
    @IBOutlet weak var changeButton: UIButton!
    
    var currentPasswordError: Bool = false
    var newPasswordError: Bool = false
    
    var current_password : String = "";
    var new_password : String = "";

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        changeButton.addTarget(self, action: #selector(self.changePassword), for: .touchUpInside)
        
        self.currentPassword.tag = 0
        self.newPassword.tag = 1
        
        self.currentPassword.delegate = self
        self.newPassword.delegate = self
        
        self.currentPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.newPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func changePassword(sender: UIButton!) {
        
        current_password = self.currentPassword.text!;
        new_password = self.newPassword.text!;
        
        if (current_password.count == 0) {
            
            self.currentPasswordError = true
            
            self.currentPasswordSeparator.backgroundColor = UIColor.red
        }
        
        if (new_password.count == 0) {
            
            self.newPasswordError = true
            
            self.newPasswordSeparator.backgroundColor = UIColor.red
        }
        
        if (!currentPasswordError && !newPasswordError) {
            
            self.setPassword(currentPassword: current_password, newPassword: new_password);
        }
    }
    
    func setPassword(currentPassword: String, newPassword: String) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SETPASSWORD)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&currentPassword=" + currentPassword + "&newPassword=" + newPassword;
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    print(response)
                    
                    if (responseError == false) {
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            DispatchQueue.main.async {
                                
                                self.currentPassword.text = ""
                                self.newPassword.text = ""
                                
                                // show message
                                
                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("alert_success_change_password", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        
                    } else {
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            DispatchQueue.main.async {
                                
                                // show message with error
                                
                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("alert_error_change_password", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();                    }
                }
            }
            
        }).resume();
    }
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        switch(textField.tag) {
            
        case 0:
            
            if (self.currentPasswordError) {
                
                self.currentPasswordError = false
                
                self.currentPasswordSeparator.backgroundColor = UIColor.lightGray
            }
            
            break
            
        default:
            
            if (self.newPasswordError) {
                
                self.newPasswordError = false
                
                self.newPasswordSeparator.backgroundColor = UIColor.lightGray
            }
            
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case self.currentPassword:
            
            self.newPassword.becomeFirstResponder()
            break
            
        default:
            
            textField.resignFirstResponder()
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
