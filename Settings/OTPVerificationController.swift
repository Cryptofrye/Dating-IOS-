//
//  OTPVerificationController.swift
//
//  Created by Mac Book on 21.08.20.
//  Copyright © 2020 raccoonsquare@gmail.com All rights reserved.
//

import Foundation
import UIKit
import Firebase

class OTPVerificationController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mInputRow: UITextField!
    @IBOutlet weak var mActionButton: UIButton!
    @IBOutlet weak var mInfoBox: UILabel!
    
    var phoneNumber : String = "";
    var verificationCode : String = "";
    
    var mVerificationInProgress : Bool = false;

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.mInputRow.delegate = self
        self.mInputRow.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        mActionButton.addTarget(self, action: #selector(self.actionButtonPressed), for: .touchUpInside)
        
        updateUI();
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if (!mVerificationInProgress) {
            
            
            
        } else {
            
            
        }
    }
    
    @objc func actionButtonPressed(sender: UIButton!) {
        
        if (!mVerificationInProgress) {
            
            phoneNumber = self.mInputRow.text!;
            
            if (phoneNumber.count > 10) {
                
                serverRequestStart();
             
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                    
                  if let error = error {
                    
                    self.showMessagePrompt(msg: error.localizedDescription)
                    
                    return
                  }
                    
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    
                  // Sign in using the verificationID and the code sent to the user
                  // ...
                    
                    self.showMessagePrompt(msg: NSLocalizedString("otp_verification_code_sent_msg", comment: ""));
                    
                    self.mVerificationInProgress = true
                    
                    self.mInputRow.text = "";
                    
                    self.updateUI();
                }
            }
            
        } else {
            
            verificationCode = self.mInputRow.text!;
            
            if (verificationCode.count == 6) {
                
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode);
                
                self.serverRequestStart();
                
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    
                  if let error = error {
                    
                    self.mInputRow.text = "";
                    
                    self.showMessagePrompt(msg: error.localizedDescription)
                    
                    return
                  }
                    
                    // User is signed in
                    
                    let currentUser = Auth.auth().currentUser
                    
                    currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                        
                        if let error = error {
                        
                            // Handle error
                            
                            self.showMessagePrompt(msg: error.localizedDescription)
                        
                            return;
                        }

                        // Send token to your backend
                        // ...
                        
                        self.serverRequestEnd();
                        
                        self.finishVerification(token: idToken!)
                    }
                }
            }
        }
    }
    
    func finishVerification(token: String) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_OTP)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&token=" + token + "&lang=en";
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                self.serverRequestEnd();
                
                self.showMessagePrompt(msg: error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        let responseVerified = response["verified"] as! Bool;
                        
                        if (responseVerified) {
                            
                            iApp.sharedInstance.setOtpVerified(otpVerified: 1);
                            iApp.sharedInstance.setOtpPhoneNumber(otpPhoneNumber: self.phoneNumber);
                            
                            iApp.sharedInstance.saveSettings();
                        }
                        
                    } else {
                        
                        // error = true
                        
                        let error_code = (response["error_code"] as AnyObject).integerValue
                        
                        switch error_code {
                            
                            case Constants.ERROR_OTP_PHONE_NUMBER_TAKEN:
                                
                                self.showMessagePrompt(msg: NSLocalizedString("otp_verification_phone_number_taken_error_msg", comment: ""))
                            
                                break;
                            
                            default:
                                
                                self.showMessagePrompt(msg: NSLocalizedString("otp_verification_error_msg", comment: ""))
                                
                                break;
                        }
                    }
                    
                    self.mVerificationInProgress = false;
                    
                    DispatchQueue.main.async() {
                    
                        self.mInputRow.text = "";
                        
                        self.updateUI();
                    }
                    
                    self.serverRequestEnd();
                    
                } catch {
                    
                    self.showMessagePrompt(msg: NSLocalizedString("otp_verification_error_msg", comment: ""))
                }
            }
            
        }).resume();
    }
    
    func updateUI() {
        
        if (iApp.sharedInstance.getOtpVerified() == 1) {
            
            mInfoBox.text = NSLocalizedString("otp_verification_success_msg", comment: "")
            mInputRow.isHidden = true;
            mActionButton.isHidden = true;
            
        } else {
            
            if (!mVerificationInProgress) {
                
                mInputRow.placeholder = NSLocalizedString("otp_phone_number_placeholder", comment: "")
                mInfoBox.text = NSLocalizedString("otp_phone_number_info", comment: "")
                
                mActionButton.setTitle(NSLocalizedString("otp_action_send_code", comment: ""), for: .normal)
                
            } else {
                
                mInputRow.placeholder = NSLocalizedString("otp_sms_code_placeholder", comment: "")
                mInfoBox.text = NSLocalizedString("otp_sms_code_info", comment: "")
                
                mActionButton.setTitle(NSLocalizedString("otp_action_check_code", comment: ""), for: .normal)
            }
        }
    }
    
    func showMessagePrompt(msg: String) {
        
        serverRequestEnd();
        
        DispatchQueue.global(qos: .background).async {
            
            DispatchQueue.main.async {
                
                // show message with error
                
                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: msg, preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        DispatchQueue.main.async() {
        
            LoadingIndicatorView.hide();
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
