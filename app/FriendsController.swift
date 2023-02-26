//
//  FriendsController.swift
//
//  Created by Demyancuk Dmitry on 27.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class FriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textMessageView: UILabel!
    
    
    var profileId: Int = 0
    
    var refreshControl = UIRefreshControl()
    
    var items = [Friend]()
    
    var itemId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var loadMoreStatus = false
    var loading = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if (profileId == 0) {
            
            profileId = iApp.sharedInstance.getId()
        }
        
        // add tableview delegate
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 65.0
        
        // add footer to delete empty cell's
        
        self.tableView.tableFooterView = UIView()
        
        // add refresh control
        
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
        self.tableView.alwaysBounceVertical = true
        
        // prepare for loading data
        
        self.showLoadingScreen()
        
        // start loading data
        
        getData()
    }
    
    @objc func refresh(sender:AnyObject) {
        
        refreshBegin(newtext: "Refresh",
                     refreshEnd: {(x:Int) -> () in
                        
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
        })
    }
    
    func refreshBegin(newtext:String, refreshEnd:@escaping (Int) -> ()) {
        
        DispatchQueue.global().async {
            
            if (!self.loading) {
                
                self.items.removeAll()
                
                self.tableView.reloadData()
                
                self.itemId = 0;
                
                self.getData()
            }
            
            DispatchQueue.global().async  {
                
                refreshEnd(0)
            }
        }
        
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
        
        var request = URLRequest(url: URL(string: Constants.METHOD_FRIENDS_GET)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&itemId=" + String(self.itemId) + "&profileId=" + String(self.profileId);
        
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
                        self.items.append(Friend(Response: itemObj))
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
            
            self.showEmptyScreen()
            
        } else {
            
            self.showContentScreen()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        
        var item: Friend;
        
        item = items[indexPath.row];
        
        cell.photoView.tag = indexPath.row
        cell.fullnameLabel.tag = indexPath.row
        
        cell.fullnameLabel.text = item.getFullname()
        cell.usernameLabel.text = "@" + item.getUsername()
    
        
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
        
        var item: Friend;
        
        item = items[indexPath.row];
        
        self.tableView.tag = item.getFriendUserId()
        
        self.performSegue(withIdentifier: "showProfile", sender: self)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }
    
    func showLoadingScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        
        self.tableView.isHidden = true
    }
    
    func showContentScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
        
        self.tableView.isHidden = false
    }
    
    func showEmptyScreen() {
        
        self.textMessageView.text = NSLocalizedString("label_empty", comment: "");
        self.textMessageView.isHidden = false
        
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
        
        self.tableView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
