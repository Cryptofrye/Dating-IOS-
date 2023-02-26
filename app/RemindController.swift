//
//  RemindController.swift
//
//  Created by Demyanchuk Dmitry on 29.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class RemindController: UIViewController {

    
    @IBOutlet weak var remindSeparator: UIView!
    
    @IBOutlet weak var remindButton: UIButton!
    
    @IBOutlet weak var remindEmail: UITextField!
    
    var emailError : Bool = false;
    
    var email : String = "";
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        remindButton.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)
        
        self.remindEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if (self.emailError) {
            
            self.emailError = false
            
            self.remindSeparator.backgroundColor = UIColor.lightGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    @objc func pressed(sender: UIButton!) {
        
        email = self.remindEmail.text!;
        
        if (email.count == 0) {
            
            self.emailError = true
            
            self.remindSeparator.backgroundColor = UIColor.red
            
        }
        
        if (!emailError) {
            
            self.remind(email: email);
        }
    }
    
    func backHandler(alert: UIAlertAction!) {
        
        self.navigationController?.popViewController(animated: false)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func remind(email: String) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_RECOVERY)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&email=" + email;
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
                    
                    if (!responseError) {
                        
                        // Link sent to emil success
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            DispatchQueue.main.async {
                                
                                // run main content storyboard
                                
                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("remind_link_sent_to_email", comment: ""), preferredStyle: UIAlertController.Style.alert)
                            
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: self.backHandler))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        
                    } else {
                        
                        // Email not found
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            DispatchQueue.main.async {
                                
                                // run main content storyboard
                                
                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("remind_error_email", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                    
                } catch let error2 as NSError {
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                    
                    print(error2)
                }
            }
            
        }).resume()
    }
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }

}
