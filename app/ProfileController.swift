//
//  ProfileController.swift
//
//  Created by Demyancuk Dmitry on 25.01.18.
//  Copyright © 2018 raccoonsquare@gmail.com All rights reserved.
//

import UIKit
import GoogleMobileAds

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var giftButton: UIButton!
    
//    var bannerView: GADBannerView!    
    
    var items = [Info]()
    
    var menuButton = UIBarButtonItem()
    var refreshControl = UIRefreshControl()
    
    var onload: Bool = false;
    
    var profile = Profile();
    
    var profileId: Int = 0
    
    
    var itemId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var loadMoreStatus = false
    var loading = false

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        actionButton.isHidden = true;
        messageButton.isHidden = true;
        
        actionButton.layer.cornerRadius = 5;
        
        if (profileId == 0) {
            
            profileId = iApp.sharedInstance.getId()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
        self.tableView.alwaysBounceVertical = true
        
        showLoadingScreen()
        
        getData(profileId: profileId)
        
//        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//        
//        addBannerViewToView(bannerView)
//        
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//        
//        bannerView.delegate = self
    }
    
//    func addBannerViewToView(_ bannerView: GADBannerView) {
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        view.addConstraints(
//            [NSLayoutConstraint(item: bannerView,
//                                attribute: .bottom,
//                                relatedBy: .equal,
//                                toItem: bottomLayoutGuide,
//                                attribute: .top,
//                                multiplier: 1,
//                                constant: 0),
//             NSLayoutConstraint(item: bannerView,
//                                attribute: .centerX,
//                                relatedBy: .equal,
//                                toItem: view,
//                                attribute: .centerX,
//                                multiplier: 1,
//                                constant: 0)
//            ])
//    }
//
//    /// Tells the delegate an ad request loaded an ad.
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        print("adViewDidReceiveAd")
//    }
//
//    /// Tells the delegate an ad request failed.
//    func adView(_ bannerView: GADBannerView,
//                didFailToReceiveAdWithError error: GADRequestError) {
//        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
//    }
//
//    /// Tells the delegate that a full-screen view will be presented in response
//    /// to the user clicking on an ad.
//    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
//        print("adViewWillPresentScreen")
//    }
//
//    /// Tells the delegate that the full-screen view will be dismissed.
//    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
//        print("adViewWillDismissScreen")
//    }
//
//    /// Tells the delegate that the full-screen view has been dismissed.
//    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
//        print("adViewDidDismissScreen")
//    }
//
//    /// Tells the delegate that a user click will open another app (such as
//    /// the App Store), backgrounding the current app.
//    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
//        print("adViewWillLeaveApplication")
//    }
    
    
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
                
                self.getData(profileId: self.profileId)
            }
            
            DispatchQueue.global().async  {
                
                refreshEnd(0)
            }
        }
        
    }
    
    func showLoadingScreen() {
        
        self.errorView.isHidden = true
        
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        
        self.tableView.isHidden = true
    }
    
    func showContentScreen() {
        
        self.errorView.isHidden = true
        
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
        
        self.tableView.isHidden = false
    }
    
    func showErrorScreen() {
        
        self.errorView.isHidden = false
        
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
        
        self.tableView.isHidden = true
    }
    
    func getData(profileId: Int) {
        
        self.loading = true;
        
        var request = URLRequest(url: URL(string: Constants.METHOD_PROFILE_GET)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&profileId=" + String(profileId) + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId();
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.showErrorScreen();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        self.profile = Profile(Response: response as AnyObject)
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            DispatchQueue.main.async {
                                
                                // show profile info
                                
                                if (self.profile.getState() != Constants.ACCOUNT_STATE_ENABLED) {
                                    
                                    self.showErrorScreen();
                                    
                                    self.errorView.text = NSLocalizedString("label_profile_blocked", comment: "")
                                    
                                } else {
                                    
                                    self.showContentScreen();
                                    self.loadingComplete();
                                }
                            }
                        }
                        
                    } else {
                        
                        // error
                        
                        DispatchQueue.main.async() {
                            
                            self.showErrorScreen();
                        }
                    }
                    
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.showErrorScreen();
                    }
                }
            }
            
        }).resume();
    }
    
    func loadingComplete() {
        
        if (self.itemsLoaded >= Constants.LIST_ITEMS) {
            
            self.loadMoreStatus = false
            
        } else {
            
            self.loadMoreStatus = true
        }
        
        self.updateProfile()
        self.updateInfo()
        
        self.tableView.reloadData()
        self.loading = false
    }
    
    func updateInfo() {
        
        var activity: String = ""
        
        if (profile.isOnline()) {
            
            activity = NSLocalizedString("label_online", comment: "")
            
        } else {
            
            activity = profile.getAuthorizeTimeAgo()
        }
        
        
        self.items.append(Info(id: self.profile.getSex(), title: NSLocalizedString("label_activity", comment: ""), detail: activity, image: UIImage(named: "ic_profile_30")!))
        
        if (self.profile.getSex() != Constants.SEX_UNKNOWN) {
            
            self.items.append(Info(id: self.profile.getSex(), title: NSLocalizedString("label_gender", comment: ""), detail: Dating.getGender(sex: self.profile.getSex()), image: UIImage(named: "ic_gender_30")!))
        }
        
        if (self.profile.getSexOrientation() != 0) {
            
            var sex_orientation_img = "ic_feature_30"
            
            switch (self.profile.getSexOrientation()) {
                
                case 1:
                    
                    sex_orientation_img = "ic_heterosexual_30"
                
                    break;
                
                case 2:
                
                    sex_orientation_img = "ic_gay_30"
                
                    break;
                
                case 3:
                
                    sex_orientation_img = "ic_lesbian_30"
                
                    break;
                
                default:
                    
                    sex_orientation_img = "ic_feature_30"
                
                    break;
            }
            
            self.items.append(Info(id: self.profile.getSexOrientation(), title: NSLocalizedString("label_sex_orientation", comment: ""), detail: Dating.getSexOrientation(sex_orientation: self.profile.getSexOrientation()), image: UIImage(named: sex_orientation_img)!))
        }
        
        if (iApp.sharedInstance.getId() != self.profile.getId() && self.profile.getAllowShowMyInfo() == 1  && !self.profile.isFriend()) {
            
            
        } else {
            
            if (self.profile.getAge() != 0) {
                
                self.items.append(Info(id: self.profile.getAge(), title: NSLocalizedString("label_age", comment: ""), detail: String(self.profile.getAge()), image: UIImage(named: "ic_age_30")!))
            }
            
            if (self.profile.getHeight() != 0) {
                
                self.items.append(Info(id: self.profile.getHeight(), title: NSLocalizedString("label_height", comment: ""), detail: String(self.profile.getHeight()), image: UIImage(named: "ic_height_30")!))
            }
            
            if (self.profile.getWeight() != 0) {
                
                self.items.append(Info(id: self.profile.getWeight(), title: NSLocalizedString("label_weight", comment: ""), detail: String(self.profile.getWeight()), image: UIImage(named: "ic_weight_30")!))
            }
            
            if (self.profile.getRelationshipStatus() != 0) {
                
                self.items.append(Info(id: self.profile.getRelationshipStatus(), title: NSLocalizedString("label_relationship_status", comment: ""), detail: Dating.getRelationshipStatus(relationshipStatus: self.profile.getRelationshipStatus()), image: UIImage(named: "ic_feature_30")!))
            }
            
            if (self.profile.getPoliticalViews() != 0) {
                
                self.items.append(Info(id: self.profile.getPoliticalViews(), title: NSLocalizedString("label_political_views", comment: ""), detail: Dating.getPoliticalViews(politicalViews: self.profile.getPoliticalViews()), image: UIImage(named: "ic_feature_30")!))
            }
            
            if (self.profile.getWorldViews() != 0) {
                
                self.items.append(Info(id: self.profile.getWorldViews(), title: NSLocalizedString("label_world_views", comment: ""), detail: Dating.getWorldViewsViews(worldViews: self.profile.getWorldViews()), image: UIImage(named: "ic_feature_30")!))
            }
            
            if (self.profile.getPersonalPriority() != 0) {
                
                self.items.append(Info(id: self.profile.getPersonalPriority(), title: NSLocalizedString("label_personal_priority", comment: ""), detail: Dating.getPersonalPriority(personalPriority: self.profile.getPersonalPriority()), image: UIImage(named: "ic_feature_30")!))
            }
            
            if (self.profile.getImportantInOthers() != 0) {
                
                self.items.append(Info(id: self.profile.getImportantInOthers(), title: NSLocalizedString("label_important_in_others", comment: ""), detail: Dating.getImportantInOthers(importantInOthers: self.profile.getImportantInOthers()), image: UIImage(named: "ic_feature_30")!))
            }
            
            if (self.profile.getSmokingViews() != 0) {
                
                self.items.append(Info(id: self.profile.getSmokingViews(), title: NSLocalizedString("label_smoking_views", comment: ""), detail: Dating.getSmokingViews(smokingViews: self.profile.getSmokingViews()), image: UIImage(named: "ic_smoking_30")!))
            }
            
            if (self.profile.getAlcoholViews() != 0) {
                
                self.items.append(Info(id: self.profile.getAlcoholViews(), title: NSLocalizedString("label_alcohol_views", comment: ""), detail: Dating.getAlcoholViews(alcoholViews: self.profile.getAlcoholViews()), image: UIImage(named: "ic_alcohol_30")!))
            }
            
            if (self.profile.getLookingFor() != 0) {
                
                self.items.append(Info(id: self.profile.getLookingFor(), title: NSLocalizedString("label_looking_for", comment: ""), detail: Dating.getLookingFor(lookingFor: self.profile.getLookingFor()), image: UIImage(named: "ic_feature_30")!))
            }
            
            if (self.profile.getGenderLike() != 0) {
                
                self.items.append(Info(id: self.profile.getGenderLike(), title: NSLocalizedString("label_gender_like", comment: ""), detail: Dating.getGenderLike(genderLike: self.profile.getGenderLike()), image: UIImage(named: "ic_like_30")!))
            }
        }
    }
    
    func updateProfile() {
        
        if (iApp.sharedInstance.getId() != self.profile.getId() && !onload && self.profile.getState() == Constants.ACCOUNT_STATE_ENABLED) {
            
            self.menuButton = UIBarButtonItem(image: UIImage(named: "ic_dots_30"), style: .plain, target: self, action: #selector(showMenu))
            self.navigationItem.rightBarButtonItem  = menuButton
        }
        
        self.onload = true;
        
        if (self.profile.getId() != iApp.sharedInstance.getId()) {
            
            self.title = self.profile.getFullname()
        }
        
        self.fullnameLabel.text = self.profile.getFullname()
        
        self.verifiedView.isHidden = true;
        
        if (self.profile.getVerified() == 1) {
            
            self.verifiedView.isHidden = false;
        }
        
        self.photoView.image = UIImage(named: "ic_profile_default_photo")
        self.coverView.image = UIImage(named: "ic_profile_default_cover")
        
        self.photoView.layer.borderWidth = 1
        self.photoView.layer.masksToBounds = false
        self.photoView.layer.borderColor = UIColor.white.cgColor
        self.photoView.layer.cornerRadius = self.photoView.frame.height/2
        self.photoView.clipsToBounds = true
        
        self.coverView.clipsToBounds = true
        
        if (self.profile.getPhotoUrl().count != 0) {
            
            let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
            self.photoView.addGestureRecognizer(imageTapGesture)
            self.photoView.isUserInteractionEnabled = true
        }
        
        showGiftButton();
        showLikeButton();
        showMessageButton();
        showActionButton()
        showPhoto()
        showCover()
    }
    
    @IBAction func giftButtonTap(_ sender: Any) {
        
        self.performSegue(withIdentifier: "selectGift", sender: self)
    }
    
    func showGiftButton() {
        
        self.giftButton.isHidden = false
        
        if (self.profile.getId() == iApp.sharedInstance.getId()) {
            
            self.giftButton.isHidden = true
            
        } else {
            
            self.giftButton.isHidden = false
        }
    }
    
    
    @IBAction func messageButtonTap(_ sender: Any) {
        
        self.performSegue(withIdentifier: "showChat", sender: self)
    }
    
    func showMessageButton() {
        
        if (self.profile.getId() == iApp.sharedInstance.getId()) {
            
            self.messageButton.isHidden = true
            
        } else {
            
            if (self.profile.isInBlackList()) {
                
                self.messageButton.isHidden = true
                
            } else {
                
                if (self.profile.getAllowMessages() == 1) {
                    
                    self.messageButton.isHidden = false
                    
                } else {
                    
                    if (self.profile.isFriend()) {
                        
                        self.messageButton.isHidden = false;
                        
                    } else {
                        
                        self.messageButton.isHidden = true;
                    }
                }
            }
        }
    }
    
    @IBAction func actionButtonTap(_ sender: Any) {
        
        if (self.profile.getId() == iApp.sharedInstance.getId()) {
            
            self.performSegue(withIdentifier: "editProfile", sender: self)
            
        } else {
            
            if (self.profile.isFriend()) {
                
                self.friendsRemove(profileId: self.profile.getId())
                
            } else {
                
                if (!profile.isFollow()) {
                    
                    self.friendsSendRequest(profileId: self.profile.getId())
                }
            }
        }
    }
    
    func showActionButton() {
        
        actionButton.backgroundColor = Helper.hexStringToUIColor(hex: "#e3403b")
        actionButton.setTitleColor(UIColor.white, for: .normal)
        
        self.actionButton.isHidden = false
        
        if (self.profile.getId() == iApp.sharedInstance.getId()) {
            
            self.actionButton.isEnabled = true
        
            self.actionButton.setTitle(NSLocalizedString("action_edit", comment: ""), for: .normal)
            
        } else {
            
            if (self.profile.isFriend()) {
                
                self.actionButton.isEnabled = true
                
                self.actionButton.setTitle(NSLocalizedString("action_remove_from_freinds", comment: ""), for: .normal)
                
            } else {
                
                if (!profile.isFollow()) {
                    
                    self.actionButton.isEnabled = true
                    
                    self.actionButton.setTitle(NSLocalizedString("action_add_to_freinds", comment: ""), for: .normal)
                    
                } else {
                    
                    actionButton.backgroundColor = Helper.hexStringToUIColor(hex: "#f2f2f2")
                    actionButton.setTitleColor(UIColor.darkGray, for: .disabled)
                    
                    self.actionButton.isEnabled = false
                    
                    self.actionButton.setTitle(NSLocalizedString("label_pending", comment: ""), for: .normal)
                }
            }
        }
    }
    
    @IBAction func likeButonTap(_ sender: Any) {
        
        self.like(profileId: profile.getId())
    }
    
    func showLikeButton() {
        
        self.likeButton.isHidden = false
        
        if (self.profile.getId() == iApp.sharedInstance.getId()) {
            
            self.likeButton.isHidden = true
            
        } else {
            
            if (self.profile.isMyLike()) {
                
                self.likeButton.isHidden = true
                
            } else {
                
                self.likeButton.isHidden = false
            }
        }
    }
    
    @objc func showMenu() {
        
        let alertController = UIAlertController(title: self.profile.getFullname(), message: self.profile.getUsername(), preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
            
        }
        
        alertController.addAction(cancelAction)
        
        if (self.profile.isBlocked()) {
         
            let unBlockAction = UIAlertAction(title: NSLocalizedString("action_unblock", comment: ""), style: .default) { action in
                
                self.unblock(profileId: self.profile.getId())
            }
            
            alertController.addAction(unBlockAction)
            
        } else {
            
            let blockAction = UIAlertAction(title: NSLocalizedString("action_block", comment: ""), style: .default) { action in
                
                self.block(profileId: self.profile.getId())
            }
            
            alertController.addAction(blockAction)
        }
        
        let reportAction = UIAlertAction(title: NSLocalizedString("action_report", comment: ""), style: .default) { action in
            
            self.showReportMenu();
        }
        
        alertController.addAction(reportAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showReportMenu() {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_abuse_report", comment: ""), message: self.profile.getFullname(), preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
                
        let spamAction = UIAlertAction(title: NSLocalizedString("label_report_spam", comment: ""), style: .default) { action in
            
            self.report(profileId: self.profile.getId(), reason: 0) // 0 = Spam
        }
        
        alertController.addAction(spamAction)
        
        let hateAction = UIAlertAction(title: NSLocalizedString("label_report_hate", comment: ""), style: .default) { action in
            
            self.report(profileId: self.profile.getId(), reason: 1) // 1 = Hate Speech
        }
        
        alertController.addAction(hateAction)
        
        let nudityAction = UIAlertAction(title: NSLocalizedString("label_report_nudity", comment: ""), style: .default) { action in
            
            self.report(profileId: self.profile.getId(), reason: 2) // 2 = Nudity
        }
        
        alertController.addAction(nudityAction)
        
        let fakeAction = UIAlertAction(title: NSLocalizedString("label_report_fake", comment: ""), style: .default) { action in
            
            self.report(profileId: self.profile.getId(), reason: 3) // 3 = Fake profile
        }
        
        alertController.addAction(fakeAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPhoto() {
        
        if (self.profile.getPhotoUrl().count != 0 && Helper.isInternetAvailable()) {
            
            if (iApp.sharedInstance.getCache().object(forKey: self.profile.getPhotoUrl() as AnyObject) != nil) {
                
                self.photoView.image = iApp.sharedInstance.getCache().object(forKey: self.profile.getPhotoUrl() as AnyObject) as? UIImage
                
            } else {
             
                let imageUrl:URL = URL(string: self.profile.getPhotoUrl())!
                
                DispatchQueue.global().async {
                    
                    let data = try? Data(contentsOf: imageUrl)
                    
                    DispatchQueue.main.async {
                        
                        if data != nil {
                            
                            let img = UIImage(data: data!)
                            
                            self.photoView.image = img
                            
                            iApp.sharedInstance.getCache().setObject(img!, forKey: self.profile.getPhotoUrl() as AnyObject)
                        }
                    }
                }
                
            }
        }
    }
    
    func showCover() {
        
        if (self.profile.getCoverUrl().count != 0 && Helper.isInternetAvailable()) {
            
            if (iApp.sharedInstance.getCache().object(forKey: self.profile.getCoverUrl() as AnyObject) != nil) {
                
                self.coverView.image = iApp.sharedInstance.getCache().object(forKey: self.profile.getCoverUrl() as AnyObject) as? UIImage
                
            } else {
                
                let imageUrl:URL = URL(string: self.profile.getCoverUrl())!
                
                DispatchQueue.global().async {
                    
                    let data = try? Data(contentsOf: imageUrl)
                    
                    DispatchQueue.main.async {
                        
                        if data != nil {
                            
                            let img = UIImage(data: data!)
                            
                            self.coverView.image = img
                            
                            iApp.sharedInstance.getCache().setObject(img!, forKey: self.profile.getCoverUrl() as AnyObject)
                        }
                    }
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "editProfile") {
            
            // Create a new variable to store the instance of ProfileController
            // segue.destination as! SettingsController
            
        } else if (segue.identifier == "showGallery") {
            
            let destinationVC = segue.destination as! GalleryController
            destinationVC.profileId = self.profile.getId()
            
        } else if (segue.identifier == "showFriends") {
            
            let destinationVC = segue.destination as! FriendsController
            destinationVC.profileId = self.profile.getId()
            
        } else if (segue.identifier == "showLikes") {
            
            let destinationVC = segue.destination as! LikesController
            destinationVC.profileId = self.profile.getId()
            
        } else if (segue.identifier == "showChat") {
            
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.profileId = self.profile.getId()
            
            destinationVC.with_user_username = self.profile.getUsername()
            destinationVC.with_user_username = self.profile.getFullname()
            destinationVC.with_user_photo_url = self.profile.getPhotoUrl()
            
            destinationVC.with_android_fcm_regid = self.profile.get_android_fcm_regId()
            destinationVC.with_ios_fcm_regid = self.profile.get_ios_fcm_regId()
            
        } else if (segue.identifier == "showGifts") {
            
            let destinationVC = segue.destination as! GiftsController
            destinationVC.profileId = self.profile.getId()
            
        } else if (segue.identifier == "selectGift") {
            
            let destinationVC = segue.destination as? UINavigationController
            
            let selectGiftVC = destinationVC?.viewControllers.first as! SelectGiftController
            
            selectGiftVC.profileId = self.profile.getId()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String? {
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            
            return 4
            
        } else {
            
            return items.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
         
            var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "InfoCell")!
            
            if (cell == nil) {
                
                cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "InfoCell")
            }
            
            switch indexPath.row {
                
            case 0:
                
                cell?.textLabel?.text  = NSLocalizedString("label_gallery", comment: "")
                cell?.detailTextLabel?.text = String(self.profile.getPhotosCount())
                
                break;
                
            case 1:
                
                cell?.textLabel?.text  = NSLocalizedString("label_friends", comment: "")
                cell?.detailTextLabel?.text = String(self.profile.getFriendsCount())
                
                break;
                
            case 2:
                
                cell?.textLabel?.text  = NSLocalizedString("label_likes", comment: "")
                cell?.detailTextLabel?.text = String(self.profile.getLikesCount())
                
                break;
                
            case 3:
                
                cell?.textLabel?.text  = NSLocalizedString("label_gifts", comment: "")
                cell?.detailTextLabel?.text = String(self.profile.getGiftsCount())
                
                break;
                
            default:
                
                break
            }
            
            return cell!
            
        } else {
            
            var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AddonCell")!
            
            if (cell == nil) {
                
                cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "AddonCell")
            }
            
            let item = self.items[indexPath.row]
            
            cell?.textLabel?.text  = item.getTitle()
            cell?.imageView?.image  = item.getImage()
            cell?.detailTextLabel?.text = item.getDetail()
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 0) {
            
            switch indexPath.row {
                
            case 0:
                
                if (iApp.sharedInstance.getId() != self.profile.getId() && self.profile.getAllowShowMyGallery() == 1  && !self.profile.isFriend()) {
                    
                    
                } else {
                    
                    self.performSegue(withIdentifier: "showGallery", sender: self)
                }
                
                break;
                
            case 1:
                
                if (iApp.sharedInstance.getId() != self.profile.getId() && self.profile.getAllowShowMyFriends() == 1  && !self.profile.isFriend()) {
                    
                    
                } else {
                    
                    self.performSegue(withIdentifier: "showFriends", sender: self)
                }
                
                break;
                
            case 2:
                
                if (iApp.sharedInstance.getId() != self.profile.getId() && self.profile.getAllowShowMyLikes() == 1  && !self.profile.isFriend()) {
                    
                    
                } else {
                    
                    self.performSegue(withIdentifier: "showLikes", sender: self)
                }
                
                break;
                
            case 3:
                
                if (iApp.sharedInstance.getId() != self.profile.getId() && self.profile.getAllowShowMyGifts() == 1  && !self.profile.isFriend()) {
                    
                    
                } else {
                    
                    self.performSegue(withIdentifier: "showGifts", sender: self)
                }
                
                break;
                
            default:
                
                break
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
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
    
    @objc func dismissFullscreenImage(gesture: UIGestureRecognizer) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        gesture.view?.removeFromSuperview()
    }
    
    func friendsRemove(profileId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_FRIENDS_REMOVE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&friendId=" + String(profileId);
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
                        
                        self.profile.setFriend(friend: false)
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        
                        self.updateProfile();
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
    
    func friendsSendRequest(profileId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_FRIENDS_SEND_REQUEST)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&profileId=" + String(profileId);
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
                        
                        self.profile.setFollow(follow: true)
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        
                        self.updateProfile();
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
    
    func unblock(profileId: Int) {
        
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
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        self.profile.setBlocked(blocked: false)
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
    
    func block(profileId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_BLACKLIST_ADD)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&profileId=" + String(profileId);
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
                        
                        self.profile.setBlocked(blocked: true)
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
    
    func like(profileId: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_PROFILE_LIKE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&profileId=" + String(profileId);
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
                        
                        DispatchQueue.main.async() {
                            
                            self.profile.setMyLike(myLike: true)
                            self.showLikeButton()
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
    
    func report(profileId: Int, reason: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_PROFILE_REPORT)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&profileId=" + String(profileId) + "&reason=" + String(reason);
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
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
