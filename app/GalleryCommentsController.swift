//
//  GalleryCommentsController.swift
//
//  Created by Demyanchuk Dmitry on 17.07.20.
//  Copyright © 2020 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class GalleryCommentsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textMessageView: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var commentEditView: UITextField!
    
    var commentText = ""
    var replyToId = 0
    
    var item = Photo()
    
    var loading = false;
    var loadStatus = false;
    
    var itemId: Int = 0
    
    var items = [Comment]()
    
    var commentId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var scroll = false

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // add footer to delete empty cell's
        
        self.tableView.tableFooterView = UIView()
        
        self.commentEditView.delegate = self;
        
        // add tableview delegate
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100.0
        
        showLoadingScreen()
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // hide tabbar
        
        self.tabBarController?.tabBar.isHidden = true
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideAdmobBanner"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        // show tabbar
        
        self.tabBarController?.tabBar.isHidden = false
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateAdmobBanner"), object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            
            if self.view.frame.origin.y == 0 {
                
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            
            if self.view.frame.origin.y != 0 {
                
                self.view.frame.origin.y += keyboardSize.height
                
                if (self.scroll) {
                    
                    self.scroll = false;
                    
                    let numberOfSections = self.tableView.numberOfSections
                    let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
                    
                    let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
                    self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.commentText = self.commentEditView.text!

        if (self.commentText.count > 0) {
            
            let comment = Comment()
            
            comment.setComment(comment: self.commentText)
            comment.getOwner().setPhotoUrl(photoUrl: iApp.sharedInstance.getPhotoUrl())
            comment.getOwner().setFullname(fullname: iApp.sharedInstance.getFullname())
            comment.getOwner().setUsername(username: iApp.sharedInstance.getUsername())
            
            if (iApp.sharedInstance.getPhotoUrl().count > 0) {
                
                comment.getOwner().setPhotoUrl(photoUrl: iApp.sharedInstance.getPhotoUrl())
            }
            
            comment.getOwner().setId(id: iApp.sharedInstance.getId())
            comment.setTimeAgo(timeAgo: "Just now")
            
            items.append(comment)
            
            self.tableView.reloadData()
            
            self.send();

            self.commentText = ""
            self.commentEditView.text = ""
            self.replyToId = 0
            
            self.showContentScreen()
            
            self.view.endEditing(true)
            
            scroll = true
            
        }
        
        return false
    }
    
    func getData() {
        
        loading = true;
        
        var request = URLRequest(url: URL(string: Constants.METHOD_GALLERY_GET_ITEM)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemId=" + String(self.itemId);
        
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
                    
                    self.item = Photo(Response: itemsArray[0] as AnyObject)
                    
                    
                    //Get comments obj array
                    let commentsObj = response["comments"] as AnyObject
                    
                    //Get comments array
                    let commentsArray = commentsObj["items"] as! [AnyObject]
                    
                    // Reverse Array
                    var reversedArray = [AnyObject]()
                    
                    for arrayIndex in stride(from: commentsArray.count - 1, through: 0, by: -1) {
                        
                        reversedArray.append(commentsArray[arrayIndex])
                    }
                    
                    //Items in array
                    self.itemsLoaded = commentsArray.count
                    
                    //Read items from array
                    for itemObj in reversedArray {
                        
                        //add item to adapter(array). insert to start | append to end
                        self.items.append(Comment(Response: itemObj))
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
        
        self.tableView.reloadData()
        self.loading = false
        
        if (self.items.count == 0) {
            
            self.showEmptyScreen()
            
        } else {
            
            self.showContentScreen()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCommentCell", for: indexPath) as! GalleryCommentCell
        
        var item: Comment;
        
        item = items[indexPath.row];
        
        cell.photoView.tag = indexPath.row
        cell.fullnameView.tag = indexPath.row
        
        cell.fullnameView.text = item.getOwner().getFullname()
        cell.commentView.text = item.getComment()
        cell.timeAgoView.text = item.getTimeAgo()
        
        
        cell.photoView.layer.borderWidth = 1
        cell.photoView.layer.masksToBounds = false
        cell.photoView.layer.borderColor = UIColor.lightGray.cgColor
        cell.photoView.layer.cornerRadius = cell.photoView.frame.height/2
        cell.photoView.clipsToBounds = true
        
        cell.photoView.image = UIImage(named: "ic_profile_default_photo")
        
        if (item.getOwner().getPhotoUrl().count == 0) {
            
            cell.photoView.image = UIImage(named: "ic_profile_default_photo")
            
        } else {
            
            if (iApp.sharedInstance.getCache().object(forKey: item.getOwner().getPhotoUrl() as AnyObject) != nil) {
                
                cell.photoView.image = iApp.sharedInstance.getCache().object(forKey: item.getOwner().getPhotoUrl() as AnyObject) as? UIImage
                
            } else {
                
                if (!item.photoLoading) {
                    
                    item.photoLoading = true;
                    
                    let imageUrlString = item.getOwner().getPhotoUrl()
                    let imageUrl:URL = URL(string: imageUrlString)!
                    
                    DispatchQueue.global().async {
                        
                        let data = try? Data(contentsOf: imageUrl)
                        
                        DispatchQueue.main.async {
                            
                            if data != nil {
                                
                                let img = UIImage(data: data!)
                                
                                cell.photoView.image = img
                                
                                iApp.sharedInstance.getCache().setObject(img!, forKey: item.getOwner().getPhotoUrl() as AnyObject)
                                
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
        
        var item: Comment;
        
        item = items[indexPath.row];
        
        if (item.getItemFromUserId() == iApp.sharedInstance.getId() && item.getOwner().getId() == iApp.sharedInstance.getId()) {
            
            showMyCommentMenu(commentId: item.getId(), index: indexPath.row, indexPath: indexPath)
            
        } else if (item.getItemFromUserId() == iApp.sharedInstance.getId() && item.getOwner().getId() != iApp.sharedInstance.getId()) {
            
            // my Item and not my comment | remove and reply
            
            self.showMyItemMenu(commentId: item.getId(), index: indexPath.row, replyToId: item.getOwner().getId(), indexPath: indexPath)
            
        } else if (item.getItemFromUserId() != iApp.sharedInstance.getId() && item.getOwner().getId() == iApp.sharedInstance.getId()) {
            
            // not my Item and my comment | remove only
            
            showMyCommentMenu(commentId: item.getId(), index: indexPath.row, indexPath: indexPath)
            
        } else {
            
            // not my Item and not my comment } reply only
            
            self.showReplyMenu(replyToId: item.getOwner().getId(), indexPath: indexPath)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showMyItemMenu(commentId: Int, index: Int, replyToId: Int, indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_choice_action", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        let replyAction = UIAlertAction(title: NSLocalizedString("action_reply", comment: ""), style: .default) { action in
            
            self.replyToId = replyToId
            
            self.commentEditView.becomeFirstResponder()
        }
        
        alertController.addAction(replyAction)
        
        let viewProfileAction = UIAlertAction(title: NSLocalizedString("action_view_profile", comment: ""), style: .default) { action in
            
            self.tableView.tag = replyToId
            
            self.performSegue(withIdentifier: "showProfile", sender: self)
        }
        
        alertController.addAction(viewProfileAction)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("action_delete", comment: ""), style: .default) { action in
            
            self.remove(commentId: commentId, index: index)
        }
        
        alertController.addAction(deleteAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = tableView.cellForRow(at: indexPath)
            popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMyCommentMenu(commentId: Int, index: Int, indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_choice_action", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("action_delete", comment: ""), style: .default) { action in
            
            self.remove(commentId: commentId, index: index)
        }
        
        alertController.addAction(deleteAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = tableView.cellForRow(at: indexPath)
            popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showReplyMenu(replyToId: Int, indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_choice_action", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        let replyAction = UIAlertAction(title: NSLocalizedString("action_reply", comment: ""), style: .default) { action in
            
            self.replyToId = replyToId
            
            self.commentEditView.becomeFirstResponder()
        }
        
        alertController.addAction(replyAction)
        
        let viewProfileAction = UIAlertAction(title: NSLocalizedString("action_view_profile", comment: ""), style: .default) { action in
            
            self.tableView.tag = replyToId
            
            self.performSegue(withIdentifier: "showProfile", sender: self)
        }
        
        alertController.addAction(viewProfileAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = tableView.cellForRow(at: indexPath)
            popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "showProfile") {
            
            // Create a new variable to store the instance of ProfileController
            let destinationVC = segue.destination as! ProfileController
            destinationVC.profileId = self.tableView.tag
        }
    }
  
    func remove(commentId: Int, index: Int) {
        
        var request = URLRequest(url: URL(string: Constants.METHOD_COMMENTS_REMOVE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&commentId=" + String(commentId);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        // ;)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.items.remove(at: index)
                        
                        self.loadingComplete()
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                }
            }
            
        }).resume();
    }
    
    func send() {
        
        var request = URLRequest(url: URL(string: Constants.METHOD_COMMENTS_NEW)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemId=" + String(self.itemId) + "&replyToUserId=" + String(self.replyToId) + "&commentText=" + self.commentText;
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        // ;)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.loadingComplete()
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                }
            }
            
        }).resume();
    }
    
    func showLoadingScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
        
        self.tableView.isHidden = true
        self.commentEditView.isHidden = true
    }
    
    func showContentScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        
        self.tableView.isHidden = false
        self.commentEditView.isHidden = false
    }
    
    func showEmptyScreen() {
        
        self.textMessageView.text = NSLocalizedString("label_empty", comment: "");
        self.textMessageView.isHidden = false
        
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        
        self.tableView.isHidden = true
        self.commentEditView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
