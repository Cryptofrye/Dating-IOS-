//
//  NotificationsController.swift
//
//  Created by Demyanchuk Dmitry on 27.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class NotificationsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textMessageView: UILabel!
    
    var refreshControl = UIRefreshControl()
    
    var items = [Notification]()
    
    var itemId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var loadMoreStatus = false
    var loading = false

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
        var request = URLRequest(url: URL(string: Constants.METHOD_NOTIFICATIONS_GET)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&notifyId=" + String(itemId);
        
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
                    self.itemId = (response["notifyId"] as AnyObject).integerValue
                    
                    //Get items array
                    let itemsArray = response["notifications"] as! [AnyObject]
                    
                    //Items in array
                    self.itemsLoaded = itemsArray.count
                    
                    //Read items from array
                    for itemObj in itemsArray {
                        
                        //add item to adapter(array). insert to start | append to end
                        self.items.append(Notification(Response: itemObj))
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
            
            iApp.sharedInstance.setNotificationsCount(notificationsCount: 0)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
            
            self.showContentScreen()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "showProfile") {
            
            // Create a new variable to store the instance of ProfileController
            let destinationVC = segue.destination as! ProfileController
            destinationVC.profileId = self.tableView.tag
            
        } else if (segue.identifier == "showItem") {
            
            // Create a new variable to store the instance of ProfileController
            let destinationVC = segue.destination as! ViewGalleryItemController
            destinationVC.itemId = self.tableView.tag
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        var item: Notification;
        
        item = items[indexPath.row];
        
        cell.photoView.tag = indexPath.row
        cell.textView.tag = indexPath.row
        
        switch item.getType() {
            
            case Constants.NOTIFY_TYPE_LIKE:
                
                cell.textView.text = item.getFullname() + " " + NSLocalizedString("label_likes_profile", comment: "")
            
                break;
            
            case Constants.NOTIFY_TYPE_GIFT:
                
                cell.textView.text = item.getFullname() + " " + NSLocalizedString("label_gift_added", comment: "")
            
                break;
            
            case Constants.NOTIFY_TYPE_COMMENT:
                
                cell.textView.text = item.getFullname() + " " + NSLocalizedString("label_comment_added", comment: "")
            
                break;
            
            case Constants.NOTIFY_TYPE_FOLLOWER:
                
                cell.textView.text = item.getFullname() + " " + NSLocalizedString("label_friend_request_added", comment: "")
            
                break;
            
            case Constants.NOTIFY_TYPE_COMMENT_REPLY:
                
                cell.textView.text = item.getFullname() + " " + NSLocalizedString("label_comment_reply_added", comment: "")
            
                break;
            
            case Constants.NOTIFY_TYPE_IMAGE_LIKE:
                
                cell.textView.text = item.getFullname() + " " + NSLocalizedString("label_likes_item", comment: "")
            
                break;
            
            case Constants.NOTIFY_TYPE_IMAGE_COMMENT:
                
                cell.textView.text = item.getFullname() + " " + NSLocalizedString("label_comment_added", comment: "")
            
                break;
            
            case Constants.NOTIFY_TYPE_IMAGE_COMMENT_REPLY:
                
                cell.textView.text = item.getFullname() + " " + NSLocalizedString("label_comment_reply_added", comment: "")
            
                break;
            
            case Constants.NOTIFY_TYPE_MEDIA_APPROVE:
                
                cell.textView.text = NSLocalizedString("label_media_approve", comment: "")
                
                break;
            
            case Constants.NOTIFY_TYPE_MEDIA_REJECT:
                
                cell.textView.text = NSLocalizedString("label_media_reject", comment: "")
                
                break;
            
            case Constants.NOTIFY_TYPE_PROFILE_PHOTO_REJECT:
                
                cell.textView.text = NSLocalizedString("label_profile_photo_reject", comment: "")
                
                break;
            
            case Constants.NOTIFY_TYPE_PROFILE_COVER_REJECT:
                
                cell.textView.text = NSLocalizedString("label_profile_cover_reject", comment: "")
                
                break;
            
            default:
                
                cell.textView.text = item.getFullname()
            
                break;
        }
        
        cell.timeAgoView.text = item.getTimeAgo()
        
        cell.photoView.layer.borderWidth = 1
        cell.photoView.layer.masksToBounds = false
        cell.photoView.layer.borderColor = UIColor.lightGray.cgColor
        cell.photoView.layer.cornerRadius = cell.photoView.frame.height/2
        cell.photoView.clipsToBounds = true
        
        cell.photoView.image = UIImage(named: "AppIcon")
        
        if (item.getPhotoUrl().count == 0) {
            
            if (item.getFromUserId() > 0) {
                
                cell.photoView.image = UIImage(named: "ic_profile_default_photo")
                
            } else {
                
                cell.photoView.image = UIImage(named: "AppIcon")
            }
            
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
        
        var item: Notification;
        
        item = items[indexPath.row];
        
        self.tableView.tag = item.getFromUserId()
        
        switch item.getType() {
            
            case Constants.NOTIFY_TYPE_FOLLOWER:
                
                let alertController = UIAlertController(title: NSLocalizedString("label_friend_request", comment: ""), message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                    
                }
                
                alertController.addAction(cancelAction)
                
                let rejectAction = UIAlertAction(title: NSLocalizedString("action_reject", comment: ""), style: .default) { action in
                    
                    self.friendsRejectRequest(friendId: item.getFromUserId(), index: indexPath.row)
                }
                
                alertController.addAction(rejectAction)
                
                let acceptAction = UIAlertAction(title: NSLocalizedString("action_accept", comment: ""), style: .default) { action in
                    
                    self.friendsAcceptRequest(friendId: item.getFromUserId(), index: indexPath.row)
                }
                
                alertController.addAction(acceptAction)
                
                if let popoverController = alertController.popoverPresentationController {
                    
                    popoverController.sourceView = tableView.cellForRow(at: indexPath)
                    popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
                }
                
                self.present(alertController, animated: true, completion: nil)
            
                break;
            
            case Constants.NOTIFY_TYPE_LIKE:
                
                self.tableView.tag = item.getFromUserId()
                
                self.performSegue(withIdentifier: "showProfile", sender: self)
            
                break;
            
            case Constants.NOTIFY_TYPE_PROFILE_PHOTO_REJECT:
                
                self.tableView.tag = item.getItemId()
                
                self.performSegue(withIdentifier: "showProfile", sender: self)
                
                break;
            
            case Constants.NOTIFY_TYPE_PROFILE_COVER_REJECT:
                
                self.tableView.tag = item.getItemId()
                
                self.performSegue(withIdentifier: "showProfile", sender: self)
                
                break;
            
            case Constants.NOTIFY_TYPE_IMAGE_LIKE:
                
                self.tableView.tag = item.getItemId()
            
                self.performSegue(withIdentifier: "showItem", sender: self)
            
                break;
            
            case Constants.NOTIFY_TYPE_MEDIA_APPROVE:
                
                self.tableView.tag = item.getItemId()
                
                self.performSegue(withIdentifier: "showItem", sender: self)
                
                break;
            
            case Constants.NOTIFY_TYPE_MEDIA_REJECT:
                
                self.tableView.tag = item.getItemId()
                
                self.performSegue(withIdentifier: "showItem", sender: self)
                
                break;
            
            case Constants.NOTIFY_TYPE_IMAGE_COMMENT:
            
                self.tableView.tag = item.getItemId()
            
                self.performSegue(withIdentifier: "showItem", sender: self)
            
                break;
            
            case Constants.NOTIFY_TYPE_IMAGE_COMMENT_REPLY:
            
                self.tableView.tag = item.getItemId()
            
                self.performSegue(withIdentifier: "showItem", sender: self)
            
                break;
            
            default:
            
                break;
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func friendsRejectRequest(friendId: Int, index: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_FRIENDS_REJECT)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&friendId=" + String(friendId);
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
                        
                        self.items.remove(at: index)
                        
                        DispatchQueue.main.async() {
                            
                            self.tableView.reloadData()
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
    
    
    func friendsAcceptRequest(friendId: Int, index: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_FRIENDS_ACCEPT)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&friendId=" + String(friendId);
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
                        
                        self.items.remove(at: index)
                        
                        DispatchQueue.main.async() {
                            
                            self.tableView.reloadData()
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
        
        self.tableView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
