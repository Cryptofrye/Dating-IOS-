//
//  BlacklistController.swift
//
//  Created by Demyanchuk Dmitry on 26.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class BlacklistController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textMessageView: UILabel!
    
    
    var preload = true
    
    var items = [Blacklist]()
    
    var itemId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var loadMoreStatus = false
    var loading = false
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 65.0
        
        self.tableView.tableFooterView = UIView()
        
        // prepare for loading data
        
        self.loadingIndicator.isHidden = false;
        self.loadingIndicator.startAnimating()
        
        self.textMessageView.isHidden = true;
        self.textMessageView.text = NSLocalizedString("label_empty", comment: "");
        
        self.tableView.isHidden = true
        
        getData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if ((offsetY > contentHeight - scrollView.frame.size.height) && !loading && items.count >= Constants.LIST_ITEMS) {
            
            loadMore()
        }
    }
    
    func loadMore() {
        
        if (!loadMoreStatus) {
            
            self.loadMoreStatus = true

            loadMoreBegin(newtext: "Load more",
                          loadMoreEnd: {(x:Int) -> () in
                            self.tableView.reloadData()
                            self.loadMoreStatus = false
            })
        }
    }
    
    func loadMoreBegin(newtext:String, loadMoreEnd:@escaping (Int) -> ()) {
        
        self.getData();
    }
    
    func getData() {
        
        loading = true;
        
        var request = URLRequest(url: URL(string: Constants.METHOD_BLACKLIST_GET)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&itemId=" + String(itemId);
        
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
                
                return
            }
            
            do {
                
                //Get Response
                let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                
                //Get Error status
                let responseError = response["error"] as! Bool;
                
                //If error False - read data
                if (responseError == false) {
                    
                    //Get itemId
                    self.itemId = (response["itemId"] as AnyObject).integerValue
                    
                    //Get items array
                    let itemsArray = response["items"] as! [AnyObject]
                    
                    //Items in array
                    self.itemsLoaded = itemsArray.count
                    
                    //Read items from array
                    for itemObj in itemsArray {
                        
                        //add item to adapter(array). insert to start | append to end
                        self.items.append(Blacklist(Response: itemObj))
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
                
            } catch {
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
            }
            
        }).resume();
    }
    
    func loadingComplete() {
        
        if (self.itemsLoaded >= Constants.LIST_ITEMS) {
            
            self.loadMoreStatus = false
            
        } else {
            
            self.loadMoreStatus = true
        }
        
        self.tableView.reloadData()
        self.loading = false
        
        if (self.items.count == 0) {
            
            self.loadingIndicator.isHidden = true;
            self.loadingIndicator.stopAnimating()
            
            self.textMessageView.isHidden = false;
            self.textMessageView.text = NSLocalizedString("label_empty", comment: "");
            
            self.tableView.isHidden = true
            
        } else {
            
            self.loadingIndicator.isHidden = true;
            self.loadingIndicator.stopAnimating()
            
            self.textMessageView.isHidden = true;
            
            self.tableView.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "showProfile") {
            
            // Create a new variable to store the instance of ProfileController
            let destinationVC = segue.destination as! ProfileController
            destinationVC.profileId = self.tableView.tag
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String? {
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlacklistCell", for: indexPath) as! BlacklistCell
        
        var item: Blacklist;
        
        item = items[indexPath.row];
        
        cell.photoView.tag = indexPath.row
        cell.fullnameLabel.tag = indexPath.row
        
        
        cell.fullnameLabel.text = item.getFullname()
        
        cell.photoView.layer.borderWidth = 1
        cell.photoView.layer.masksToBounds = false
        cell.photoView.layer.borderColor = UIColor.lightGray.cgColor
        cell.photoView.layer.cornerRadius = cell.photoView.frame.height/2
        cell.photoView.clipsToBounds = true
        
        cell.photoView.image = UIImage(named: "ic_profile_default_photo")
        
        if (item.getPhotoUrl().count == 0) {
            
            cell.photoView.image = UIImage(named: "ic_profile_default_photo")
            
        } else {
            
            if (iApp.sharedInstance.getCache().object(forKey: item.getPhotoUrl() as AnyObject) != nil) {
                
                cell.photoView.image = iApp.sharedInstance.getCache().object(forKey: item.getPhotoUrl() as AnyObject) as? UIImage
                
            } else {
                
                if (!item.photoLoading) {
                    
                    item.photoLoading = true;
                    
                    let imageUrlString = item.getPhotoUrl()
                    let imageUrl:URL = URL(string: imageUrlString)!
                    
                    DispatchQueue.global().async {
                        
                        let data = try? Data(contentsOf: imageUrl)
                        
                        DispatchQueue.main.async {
                            
                            if data != nil {
                                
                                let img = UIImage(data: data!)
                                
                                cell.photoView.image = img
                                
                                iApp.sharedInstance.getCache().setObject(img!, forKey: item.getPhotoUrl() as AnyObject)
                                
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var item: Blacklist;
        
        item = items[indexPath.row];
        
        self.tableView.tag = item.getBlockedUserId()
        
        self.performSegue(withIdentifier: "showProfile", sender: self)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .normal, title: NSLocalizedString("action_unblock", comment: "")) {  (contextualAction, view, boolValue) in
            
            var item: Blacklist;
            
            item = self.items[indexPath.row];
            
            self.tableView.setEditing(false, animated: true);
            
            self.unblock(profileId: item.getBlockedUserId(), index: indexPath.row)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    
    func unblock(profileId: Int, index: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_BLACKLIST_REMOVE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&profileId=" + String(profileId);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                    self.loadingComplete();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        self.items.remove(at: index)
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        self.loadingComplete();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        self.loadingComplete();
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
