//
//  ViewGalleryItemController.swift
//
//  Created by Demynachuk Dmitry on 29.01.2021
//  Copyright © 2021 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class ViewGalleryItemController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textMessageView: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    
    var menuButton = UIBarButtonItem()
    
    var item = Photo()
    
    var pictureLoading = false;
    var photoLoading = false;
    
    var loading = false;
    var loadStatus = false;
    
    var itemId: Int = 0
    
    var items = [Comment]()
    
    var commentId: Int = 0;
    var itemsLoaded: Int = 0;
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // add tableview delegate
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300.0
        
        // add footer to delete empty cell's
        
        self.tableView.tableFooterView = UIView()
        
        showLoadingScreen()
        
        getData()
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
        if (self.item.getItemType() == Constants.ITEM_TYPE_VIDEO) {
            
            self.performSegue(withIdentifier: "showVideo", sender: self)
            
        } else {
         
            let imageView = gesture.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
            
        }
    }
    
    @objc func dismissFullscreenImage(gesture: UIGestureRecognizer) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        gesture.view?.removeFromSuperview()
    }
    
    @objc func commentTap(gesture: UIGestureRecognizer) {
        
        self.performSegue(withIdentifier: "showComments", sender: self)
    }
    
    @objc func likeTap(gesture: UIGestureRecognizer) {
        
        if (item.isMyLike()) {
            
            item.setMyLike(myLike: false)
            item.setLikesCount(likesCount: item.getLikesCount() - 1)
            
            self.tableView.reloadData()
            
        } else {
            
            item.setMyLike(myLike: true)
            item.setLikesCount(likesCount: item.getLikesCount() + 1)
            
            self.tableView.reloadData()
        }
        
        self.like()
    }
    
    func getData() {
        
        loading = true;
        
        var request = URLRequest(url: URL(string: Constants.METHOD_GALLERY_GET_ITEM)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&itemId=" + String(self.itemId);
        
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
        
        if (self.item.getId() == 0) {
            
            self.showEmptyScreen()
            
        } else {
            
            self.update()
            self.showContentScreen()
        }
    }
    
    func update() {
        
        self.tableView.reloadData()
        
        if (!self.loadStatus) {
            
            self.loadStatus = true;
            
            self.menuButton = UIBarButtonItem(image: UIImage(named: "ic_dots_30"), style: .plain, target: self, action: #selector(showMenu))
            self.navigationItem.rightBarButtonItem  = menuButton
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.item.getId() != 0) {
            
            return 1
            
        } else {
            
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryItemViewCell", for: indexPath) as! GalleryItemViewCell
        
        cell.photoView.tag = indexPath.row
        cell.fullnameLabel.tag = indexPath.row
        
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.likeTap(gesture:)) )
        let commentTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentTap(gesture:)))
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
                
        // add it to the image view;
        
        cell.likeButton.addGestureRecognizer(tapGesture)
        cell.commentButton.addGestureRecognizer(commentTapGesture)
        cell.pictureView.addGestureRecognizer(imageTapGesture)
        
        // make sure imageView can be interacted with by user
        
        cell.likeButton.isUserInteractionEnabled = true
        cell.commentButton.isUserInteractionEnabled = true
        cell.pictureView.isUserInteractionEnabled = true
        
        cell.fullnameLabel.text = self.item.getOwner().getFullname()
        cell.timeAgoLabel.text = self.item.getTimeAgo()
        
        if (self.item.getLikesCount() == 0) {
            
            cell.likesCount.text = "0"
            cell.likesCount.isHidden = true
            
        } else {
            
            cell.likesCount.text = String(self.item.getLikesCount())
            cell.likesCount.isHidden = false
        }
        
        if (self.item.getCommentsCount() == 0) {
            
            cell.commentsCountLabel.text = "0"
            cell.commentsCountLabel.isHidden = true
            
        } else {
            
            cell.commentsCountLabel.text = String(self.item.getCommentsCount())
            cell.commentsCountLabel.isHidden = false
        }
        
        if (self.item.isMyLike()) {
            
            cell.likeButton.image =  UIImage(named: "ic_like_active_30")
            
        } else {
            
            cell.likeButton.image =  UIImage(named: "ic_like_30")
        }
        
        cell.contentLabel.isHidden = true;
        
        if (self.item.getComment().count > 0) {
            
            cell.contentLabel.isHidden = false;
            cell.contentLabel.text = self.item.getComment()
        }
        
        
        cell.photoView.layer.borderWidth = 1
        cell.photoView.layer.masksToBounds = false
        cell.photoView.layer.borderColor = UIColor.lightGray.cgColor
        cell.photoView.layer.cornerRadius = cell.photoView.frame.height/2
        cell.photoView.clipsToBounds = true
        
        cell.photoView.image = UIImage(named: "ic_profile_default_photo")
        
        if (self.item.getOwner().getPhotoUrl().count == 0) {
            
            cell.photoView.image = UIImage(named: "ic_profile_default_photo")
            
        } else {
            
            if (iApp.sharedInstance.getCache().object(forKey: self.item.getOwner().getPhotoUrl() as AnyObject) != nil) {
                
                cell.photoView.image = iApp.sharedInstance.getCache().object(forKey: self.item.getOwner().getPhotoUrl() as AnyObject) as? UIImage
                
            } else {
                
                if (!item.photoLoading) {
                    
                    item.photoLoading = true;
                    
                    let imageUrlString = self.item.getOwner().getPhotoUrl()
                    let imageUrl:URL = URL(string: imageUrlString)!
                    
                    DispatchQueue.global().async {
                        
                        let data = try? Data(contentsOf: imageUrl)
                        
                        DispatchQueue.main.async {
                            
                            if data != nil {
                                
                                let img = UIImage(data: data!)
                                
                                cell.photoView.image = img
                                
                                iApp.sharedInstance.getCache().setObject(img!, forKey: self.item.getOwner().getPhotoUrl() as AnyObject)
                                
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
        }
        
        if (self.item.getImgUrl().count == 0 || self.item.getItemType() == Constants.ITEM_TYPE_VIDEO) {
            
            cell.pictureView.isHidden = false
            
            cell.pictureView.image = UIImage(named: "ic_video_preview")
            
        } else {
            
            cell.pictureView.isHidden = false
            
            if (iApp.sharedInstance.getCache().object(forKey: self.item.getImgUrl() as AnyObject) != nil) {
                
                cell.pictureView.image = iApp.sharedInstance.getCache().object(forKey: self.item.getImgUrl() as AnyObject) as? UIImage
                
            } else {
                
                if (!self.item.imgLoading) {
                    
                    self.item.imgLoading = true;
                    
                    let imageUrlString = self.item.getImgUrl()
                    let imageUrl:URL = URL(string: imageUrlString)!
                    
                    DispatchQueue.global().async {
                        
                        let data = try? Data(contentsOf: imageUrl)
                        
                        DispatchQueue.main.async {
                            
                            if data != nil {
                                
                                let img = UIImage(data: data!)
                                
                                cell.pictureView.image = img
                                
                                iApp.sharedInstance.getCache().setObject(img!, forKey: self.item.getImgUrl() as AnyObject)
                                
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
        
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "showComments") {
            
            // Create a new variable to store the instance of GalleryCommentsController
            let destinationVC = segue.destination as! GalleryCommentsController
            destinationVC.itemId = self.item.getId()
            
        } else if (segue.identifier == "showVideo") {
            
            // Create a new variable to store the instance of GalleryCommentsController
            let destinationVC = segue.destination as! ViewVideoController
            destinationVC.videoUrl = self.item.getVideoUrl();
        }
    }
    
    @objc func showMenu() {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_gallery_item_menu", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
            
        }
        
        alertController.addAction(cancelAction)
        
        if (self.item.getOwner().getId() != iApp.sharedInstance.getId()) {
            
            let reportAction = UIAlertAction(title: NSLocalizedString("action_report", comment: ""), style: .default) { action in
                
                self.showReportMenu();
            }
            
            alertController.addAction(reportAction)
            
        } else {
            
            let deleteAction = UIAlertAction(title: NSLocalizedString("action_remove", comment: ""), style: .default) { action in
                
                self.showRemoveMenu();
            }
            
            alertController.addAction(deleteAction)
        }
        
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showRemoveMenu() {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_item_remove_message", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        let yesAction = UIAlertAction(title: NSLocalizedString("action_yes", comment: ""), style: .default) { action in
            
            self.remove()
        }
        
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: NSLocalizedString("action_no", comment: ""), style: .default) { action in
            
            
        }
        
        alertController.addAction(noAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showReportMenu() {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_abuse_report", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        let spamAction = UIAlertAction(title: NSLocalizedString("label_report_spam", comment: ""), style: .default) { action in
            
            self.report(reason: 0) // 0 = Spam
        }
        
        alertController.addAction(spamAction)
        
        let hateAction = UIAlertAction(title: NSLocalizedString("label_report_hate", comment: ""), style: .default) { action in
            
            self.report(reason: 1) // 1 = Hate Speech
        }
        
        alertController.addAction(hateAction)
        
        let nudityAction = UIAlertAction(title: NSLocalizedString("label_report_nudity", comment: ""), style: .default) { action in
            
            self.report(reason: 2) // 2 = Nudity
        }
        
        alertController.addAction(nudityAction)
        
        let fakeAction = UIAlertAction(title: NSLocalizedString("label_report_piracy", comment: ""), style: .default) { action in
            
            self.report(reason: 3) // 3 = Piracy
        }
        
        alertController.addAction(fakeAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func like() {
        
        var request = URLRequest(url: URL(string: Constants.METHOD_GALLERY_LIKE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemId=" + String(self.item.getId());
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        //Get likeCount
                        self.item.setLikesCount(likesCount: (response["likesCount"] as AnyObject).integerValue)
                        
                        //Get myLike
                        self.item.setMyLike(myLike: response["myLike"] as! Bool)
                        
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.update()
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                }
            }
            
        }).resume();
    }
    
    func remove() {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_GALLERY_REMOVE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemId=" + String(self.item.getId());
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
                        
                        DispatchQueue.main.async() {
                            
                            self.serverRequestEnd();
                            
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                        
                    } else {

                        DispatchQueue.main.async() {
                            
                            self.serverRequestEnd();
                        }
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
    
    func report(reason: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_GALLERY_REPORT)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemId=" + String(self.item.getId()) + "&abuseId=" + String(reason);
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
                        
                        // ;)
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
        
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
        
        self.tableView.isHidden = true
    }
    
    func showContentScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        
        self.tableView.isHidden = false
    }
    
    func showEmptyScreen() {
        
        self.textMessageView.text = NSLocalizedString("label_item_not_exist", comment: "");
        self.textMessageView.isHidden = false
        
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        
        self.tableView.isHidden = true
    }
    

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

}
