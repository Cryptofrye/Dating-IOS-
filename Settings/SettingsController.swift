//
//  SettingsController.swift
//
//  Created by Demyanchuk Dmitry on 23.01.17.
//  Copyright © 2018 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    @IBOutlet weak var logoutItem: UITableViewCell!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
    

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
            
            case 0:
            
                return 2
            
            case 1:
            
                return 12
        
            default:
        
                return 1
        
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // logout
        
        if (indexPath.section == 2 && indexPath.row == 0) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("alert_logout", comment: ""), preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_no", comment: ""), style: .cancel) { action in
                
                
            }
            
            alertController.addAction(cancelAction)
            
            let yesAction = UIAlertAction(title: NSLocalizedString("action_yes", comment: ""), style: .default) { action in
                
                self.logout(accountId: iApp.sharedInstance.getId(), accessToken: iApp.sharedInstance.getAccessToken());
            }
            
            alertController.addAction(yesAction)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    
    func logout(accountId: Int, accessToken: String) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_LOGOUT)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=\(accountId)" + "&accessToken=" + accessToken;
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
                        
                        iApp.sharedInstance.logout();
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            DispatchQueue.main.async {
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                                let vc = storyboard.instantiateViewController(withIdentifier: "AppController");
                                
                                vc.modalPresentationStyle = .fullScreen
                                
                                // let navigationController = UINavigationController(rootViewController: vc);
                                
                                self.present(vc, animated: true, completion: nil);
                            }
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                    
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
        
        LoadingIndicatorView.show("Loading");
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }

}
