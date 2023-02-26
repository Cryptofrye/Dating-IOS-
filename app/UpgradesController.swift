//
//  UpgradesController.swift
//  SocialNetwork
//
//  Created by Demyanchuk Dmitry on 01.01.20.
//  Copyright © 2020 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class UpgradesController: UIViewController {
    
    @IBOutlet weak var ghostButton: UIButton!
    @IBOutlet weak var verifiedButton: UIButton!
    @IBOutlet weak var proModeButton: UIButton!
    @IBOutlet weak var adButton: UIButton!


    override func viewDidLoad() {
        
        super.viewDidLoad()

        update()
    }
    
    func update() {
        
        if (iApp.sharedInstance.getGhost() == 1) {
            
            self.ghostButton.isEnabled = false
            self.ghostButton.setTitle(NSLocalizedString("label_enabled", comment: ""), for: .disabled)
            
        } else {
            
            self.ghostButton.isEnabled = true
            self.ghostButton.setTitle(NSLocalizedString("action_enable", comment: "") + " (" + String(iApp.sharedInstance.getSettings().getGhostModeCost()) + ")", for: .normal)
        }
        
        if (iApp.sharedInstance.getVerified() == 1) {
            
            self.verifiedButton.isEnabled = false
            self.verifiedButton.setTitle(NSLocalizedString("label_enabled", comment: ""), for: .disabled)
            
        } else {
            
            self.verifiedButton.isEnabled = true
            self.verifiedButton.setTitle(NSLocalizedString("action_enable", comment: "") + " (" + String(iApp.sharedInstance.getSettings().getVerifiedBadgeCost()) + ")", for: .normal)
        }
        
        if (iApp.sharedInstance.getPro() == 1) {
            
            self.proModeButton.isEnabled = false
            self.proModeButton.setTitle(NSLocalizedString("label_enabled", comment: ""), for: .disabled)
            
        } else {
            
            self.proModeButton.isEnabled = true
            self.proModeButton.setTitle(NSLocalizedString("action_enable", comment: "") + " (" + String(iApp.sharedInstance.getSettings().getProModeCost()) + ")", for: .normal)
        }
        
        if (iApp.sharedInstance.getAdmob() == 1) {
            
            self.adButton.isEnabled = true
            self.adButton.setTitle(NSLocalizedString("action_enable", comment: "") + " (" + String(iApp.sharedInstance.getSettings().getDisableAdsCost()) + ")", for: .normal)
            
        } else {
            
            self.adButton.isEnabled = false
            self.adButton.setTitle(NSLocalizedString("label_enabled", comment: ""), for: .disabled)
        }
    }
    
    @IBAction func ghostButtonTap(_ sender: Any) {
        
        if (iApp.sharedInstance.getBalance() < iApp.sharedInstance.getSettings().getGhostModeCost()) {
            
            let alert = UIAlertController(title: NSLocalizedString("label_balance", comment: ""), message: NSLocalizedString("label_you_balance_null", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.upgrade(upgradeType: Constants.PA_BUY_GHOST_MODE, credits: iApp.sharedInstance.getSettings().getGhostModeCost())
        }
    }
    
    @IBAction func verifiedButtonTap(_ sender: Any) {
     
        if (iApp.sharedInstance.getBalance() < iApp.sharedInstance.getSettings().getVerifiedBadgeCost()) {
            
            let alert = UIAlertController(title: NSLocalizedString("label_balance", comment: ""), message: NSLocalizedString("label_you_balance_null", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.upgrade(upgradeType: Constants.PA_BUY_VERIFIED_BADGE, credits: iApp.sharedInstance.getSettings().getVerifiedBadgeCost())
        }
    }
    
    @IBAction func proModeButtonTap(_ sender: Any) {
        
        if (iApp.sharedInstance.getBalance() < iApp.sharedInstance.getSettings().getProModeCost()) {
            
            let alert = UIAlertController(title: NSLocalizedString("label_balance", comment: ""), message: NSLocalizedString("label_you_balance_null", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.upgrade(upgradeType: Constants.PA_BUY_PRO_MODE, credits: iApp.sharedInstance.getSettings().getProModeCost())
        }
    }
    
    @IBAction func adButtonTap(_ sender: Any) {
        
        if (iApp.sharedInstance.getBalance() < iApp.sharedInstance.getSettings().getDisableAdsCost()) {
            
            let alert = UIAlertController(title: NSLocalizedString("label_balance", comment: ""), message: NSLocalizedString("label_you_balance_null", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.upgrade(upgradeType: Constants.PA_BUY_DISABLE_ADS, credits: iApp.sharedInstance.getSettings().getDisableAdsCost())
        }
    }
    
    func upgrade(upgradeType: Int, credits: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_UPGRADE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&credits=" + String(credits) + "&upgradeType=" + String(upgradeType);
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
                    
                    if (responseError == false) {
                        
                        switch (upgradeType) {
                            
                            case Constants.PA_BUY_VERIFIED_BADGE:
                                
                                iApp.sharedInstance.setBalance(balance: iApp.sharedInstance.getBalance() - credits)
                                
                                iApp.sharedInstance.setVerified(verified: 1)
                            
                                break;
                            
                            
                            case Constants.PA_BUY_GHOST_MODE:
                                
                                iApp.sharedInstance.setBalance(balance: iApp.sharedInstance.getBalance() - credits)
                                
                                iApp.sharedInstance.setGhost(ghost: 1)
                                
                                break;
                            
                            
                            case Constants.PA_BUY_DISABLE_ADS:
                                
                                iApp.sharedInstance.setBalance(balance: iApp.sharedInstance.getBalance() - credits)
                                
                                iApp.sharedInstance.setAdmob(admob: 0)
                            
                                break;
                            
                            case Constants.PA_BUY_PRO_MODE:
                                
                                iApp.sharedInstance.setBalance(balance: iApp.sharedInstance.getBalance() - credits)
                                
                                iApp.sharedInstance.setPro(pro: 1)
                            
                                break;
                        
                            default:
                                
                                break;
                        }
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd();
                        
                        self.update();
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
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

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
