//
//  ChatViewController.swift
//
//  Created by Demyanchuk Dmitry on 05.01.18.
//  Copyright © 2018 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textMessageView: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var choiceImage: UIImageView!
    @IBOutlet weak var loadMoreButton: UIButton!
    
    
    @IBOutlet weak var messageEditView: UITextField!
    
    var with_user_state = 0;
    var with_user_verified = 0;
    
    var with_user_username = ""
    var with_user_fullname = ""
    var with_user_photo_url = ""
    
    var with_android_fcm_regid = ""
    var with_ios_fcm_regid = ""
    
    var chatUpdate = false;
    
    var messageImage = false;
    
    var messageImgUrl = ""
    var messageText = ""
    
    var messageSendText = ""
    
    var stickerId: Int = 0
    var stickerImg = ""
    
    var chatId = 0;
    var profileId = 0;
    var chatFromUserId = 0;
    var chatToUserId = 0;
    
    var items = [Message]()
    
    var itemsCount: Int = 0;
    
    var itemId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var loadMoreStatus = false
    var loading = false
    
    var inboxTyping = false
    var outboxTyping = false

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(chatId)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        self.messageEditView.delegate = self;
        self.messageEditView.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        // listener to choice image
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTap(gesture:)) )
        
        // add it to the image view;
        self.choiceImage.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        self.choiceImage.isUserInteractionEnabled = true
        self.choiceImage.clipsToBounds = true
        
        // prepare for loading data
        
        self.showLoadingScreen()
        
        // start loading data
        
        getData()
    }
    
    @IBAction func unwindToChat(segue: UIStoryboardSegue) {
        
        print("stickerId = \(stickerId)")
        print("stickerImgUrl = \(stickerImg)")
        
        if (self.stickerId != 0) {
            
            if (iApp.sharedInstance.getPro() == 0 && iApp.sharedInstance.getFreeMessagesCount() == 0) {
                
                let alertVC = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("alert_need_pro_mode", comment: ""), preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
                
                alertVC.addAction(okAction)
                
                present(alertVC, animated: true, completion: nil)
                
            } else {
                
                let msg = Message()
                
                msg.setText(text: "")
                msg.setImgUrl(imgUrl: self.stickerImg)
                msg.setStickerImgUrl(stickerImgUrl: self.stickerImg)
                msg.setStickerId(stickerId: self.stickerId)
                msg.setFromUserId(fromUserId: iApp.sharedInstance.getId())
                msg.setTimeAgo(timeAgo: "Just now")
                
                items.append(msg)
                
                send(addToTable: false);
                
                self.view.endEditing(true)
                
                self.tableView.reloadData()
                
                self.showContentScreen()
                
                let numberOfSections = self.tableView.numberOfSections
                let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
                
                let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "selectSticker") {
            
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! SelectStickerController
            destinationVC.itemId = 0
        }
    }
    
    @objc func seenChat() {
        
        if (self.chatId == iApp.sharedInstance.getCurrentChatId()) {
            
            print("seen chat")
            
            for itemObj in items {
                
                if (itemObj.getFromUserId() == iApp.sharedInstance.getId() && itemObj.getSeenAt() == 0) {
                    
                    itemObj.setSeenAt(seenAt: 1)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    func updateTyping() {
        
        if (inboxTyping) {
            
            self.navigationItem.title = NSLocalizedString("label_typing", comment: "")
            
        } else {
            
            self.navigationItem.title = NSLocalizedString("chat_view_controller_title", comment: "")
        }
    }
    
    @objc func typingStartChat() {
        
        if (self.chatId == iApp.sharedInstance.getCurrentChatId()) {
            
            self.inboxTyping = true
            
            updateTyping()
            
            print("stypingStartChat")
        }
    }
    
    @objc func typingEndChat() {
        
        if (self.chatId == iApp.sharedInstance.getCurrentChatId()) {
            
            self.inboxTyping = false
            
            updateTyping()
            
            print("typingEndChat")
        }
    }
    
    @objc func updateChat() {
        
        if (self.chatId == iApp.sharedInstance.getCurrentChatId() && iApp.sharedInstance.msg.getId() != 0) {
            
            let msg = Message()
            
            msg.setId(id: iApp.sharedInstance.msg.getId())
            msg.setFromUserId(fromUserId: iApp.sharedInstance.msg.getFromUserId())
            msg.setText(text:  iApp.sharedInstance.msg.getText())
            msg.setPhotoUrl(photoUrl: iApp.sharedInstance.msg.getPhotoUrl())
            msg.setFullname(fullname: iApp.sharedInstance.msg.getFullname())
            msg.setUsername(username: iApp.sharedInstance.msg.getUsername())
            msg.setImgUrl(imgUrl: iApp.sharedInstance.msg.getImgUrl())
            msg.setTimeAgo(timeAgo: iApp.sharedInstance.msg.getTimeAgo())
            
            items.append(msg)
            
            iApp.sharedInstance.msg.setId(id: 0)
            iApp.sharedInstance.msg.setFullname(fullname: "")
            iApp.sharedInstance.msg.setUsername(username: "")
            iApp.sharedInstance.msg.setImgUrl(imgUrl: "")
            iApp.sharedInstance.msg.setPhotoUrl(photoUrl: "")
            
            self.tableView.reloadData()
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
            self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
            
            sendNotify(notify: Constants.GCM_NOTIFY_SEEN)
            
            inboxTyping = false
            
            updateTyping()
        }
    }
    
    @objc func imageTap(gesture: UIGestureRecognizer) {
        
        if let imageView = gesture.view as? UIImageView {
            
            if (messageImage) {
                
                let alertController = UIAlertController(title: NSLocalizedString("label_choice_image", comment: ""), message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                    
                }
                
                alertController.addAction(cancelAction)
                
                let deletelAction = UIAlertAction(title: NSLocalizedString("action_delete", comment: ""), style: .default) { action in
                    
                    self.deleteImage()
                }
                
                alertController.addAction(deletelAction)
                
                if let popoverController = alertController.popoverPresentationController {
                    
                    popoverController.sourceView = imageView
                    popoverController.sourceRect = imageView.bounds
                }
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                
                let alertController = UIAlertController(title: NSLocalizedString("label_choice_action", comment: ""), message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                    
                    
                }
                
                alertController.addAction(cancelAction)
                
                let librarylAction = UIAlertAction(title: NSLocalizedString("action_send_sticker", comment: ""), style: .default) { action in
                    
                    self.selectSticker()
                }
                
                alertController.addAction(librarylAction)
                
                let cameraAction = UIAlertAction(title: NSLocalizedString("action_send_image", comment: ""), style: .default) { action in
                    
                    self.selectImage(imageView: imageView)
                }
                
                alertController.addAction(cameraAction)
                
                if let popoverController = alertController.popoverPresentationController {
                    
                    popoverController.sourceView = imageView
                    popoverController.sourceRect = imageView.bounds
                }
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func selectSticker() {
        
        self.performSegue(withIdentifier: "selectSticker", sender: self)
    }
    
    func selectImage(imageView: UIImageView) {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_choice_image", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
            
        }
        
        alertController.addAction(cancelAction)
        
        let librarylAction = UIAlertAction(title: NSLocalizedString("action_photo_from_library", comment: ""), style: .default) { action in
            
            self.photoFromLibrary()
        }
        
        alertController.addAction(librarylAction)
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("action_photo_from_camera", comment: ""), style: .default) { action in
            
            self.photoFromCamera()
        }
        
        alertController.addAction(cameraAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = imageView
            popoverController.sourceRect = imageView.bounds
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteImage() {
        
        self.messageImage = false
        self.choiceImage.image = UIImage(named: "ic_action_icon")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        var chosenImage = UIImage()
        
        chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        
        self.choiceImage.image = chosenImage
        
        self.messageImage = true
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func photoFromLibrary() {
        
        let myPickerController = UIImagePickerController()
        
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func photoFromCamera() {
        
        let myPickerController = UIImagePickerController()
        
        myPickerController.delegate = self;
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            myPickerController.allowsEditing = false
            myPickerController.sourceType = UIImagePickerController.SourceType.camera
            myPickerController.cameraCaptureMode = .photo
            myPickerController.modalPresentationStyle = .fullScreen
            
            present(myPickerController, animated: true, completion: nil)
            
        } else {
            
            let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
            
            alertVC.addAction(okAction)
            
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func loadMoreButtonTap(_ sender: Any) {
        
        getPrevious()
    }
    
    
    func getData() {
        
        loading = true;
        
        var request = URLRequest(url: URL(string: Constants.METHOD_CHAT_GET)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&msgId=" + String(self.itemId) + "&profileId=" + String(self.profileId) + "&chatId=" + String(self.chatId) + "&chatFromUserId=" + String(self.chatFromUserId) + "&chatToUserId=" + String(self.chatToUserId);
        
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
                    
                    //Get chatToUserId
                    self.chatToUserId = (response["chatToUserId"] as AnyObject).integerValue
                    
                    //Get chatFromUserId
                    self.chatFromUserId = (response["chatFromUserId"] as AnyObject).integerValue
                    
                    //Get chatId
                    self.chatId = (response["chatId"] as AnyObject).integerValue
                    iApp.sharedInstance.setCurrentChatId(chatId: self.chatId)
                    
                    //Get itemsCount
                    self.itemsCount = (response["messagesCount"] as AnyObject).integerValue
                    
                    //Get itemId
                    self.itemId = (response["msgId"] as AnyObject).integerValue
                    
                    //Get items array
                    let itemsArray = response["messages"] as! [AnyObject]
                    
                    // Reverse Array
                    var reversedArray = [AnyObject]()
                    
                    for arrayIndex in stride(from: itemsArray.count - 1, through: 0, by: -1) {
                        
                        reversedArray.append(itemsArray[arrayIndex])
                    }
                    
                    //Items in array
                    self.itemsLoaded = itemsArray.count
                    
                    //Read items from array
                    for itemObj in reversedArray {
                        
                        //add item to adapter(array). insert to start | append to end
                        self.items.append(Message(Response: itemObj))
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    
                    if (!self.chatUpdate) {
                        
                        self.update()
                    }
                    
                    self.loadingComplete()
                    
                    if (self.items.count > 0) {
                        
                        let numberOfSections = self.tableView.numberOfSections
                        let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
                        
                        let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
                        self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
                    }
    
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
        
        if (itemsCount > items.count) {
            
            self.loadMoreButton.isHidden = false
            
        } else {
            
            self.loadMoreButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChat), name: NSNotification.Name(rawValue: "updateChat"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(seenChat), name: NSNotification.Name(rawValue: "seenChat"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(typingStartChat), name: NSNotification.Name(rawValue: "typingStartChat"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(typingEndChat), name: NSNotification.Name(rawValue: "typingEndChat"), object: nil)
        
        // hide tabbar
        
        self.tabBarController?.tabBar.isHidden = true
        
        if (iApp.sharedInstance.getAdmob() == 1) {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideAdmobBanner"), object: nil)
        }
        
        iApp.sharedInstance.setCurrentChatId(chatId: chatId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        update()
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateChat"), object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "seenChat"), object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "typingStartChat"), object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "typingEndChat"), object: self.view.window)
        
        if (self.outboxTyping) {
            
            self.outboxTyping = false
            
            sendNotify(notify: Constants.GCM_NOTIFY_TYPING_END)
        }
        
        // show tabbar
        
        self.tabBarController?.tabBar.isHidden = false
        
        if (iApp.sharedInstance.getAdmob() == 1) {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateAdmobBanner"), object: nil)
        }
        
        iApp.sharedInstance.setCurrentChatId(chatId: 0)
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
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let text = self.messageEditView.text!
        
        if (text.count == 0 && self.outboxTyping) {
            
            self.outboxTyping = false
            
            sendNotify(notify: Constants.GCM_NOTIFY_TYPING_END)
            
        } else {
            
            if (!self.outboxTyping && text.count > 0) {
                
                self.outboxTyping = true
                sendNotify(notify: Constants.GCM_NOTIFY_TYPING_START)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            self.messageText = self.messageEditView.text!
            
            if (self.messageImage || self.messageText.count > 0) {
                
                self.messageSendText = messageText;
                
                if (iApp.sharedInstance.getPro() == 0 && iApp.sharedInstance.getFreeMessagesCount() == 0) {
                    
                    let alertVC = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("alert_need_pro_mode", comment: ""), preferredStyle: .actionSheet)
                    
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    
                    })
                    
                    if let popoverController = alertVC.popoverPresentationController {
                        
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    
                    if (self.messageImage) {
                        
                        self.uploadImage()
                        
                    } else {
                        
                        if (self.messageText.count > 0) {
                            
                            let msg = Message()
                            
                            msg.setText(text: self.messageSendText)
                            msg.setImgUrl(imgUrl: "")
                            msg.setFromUserId(fromUserId: iApp.sharedInstance.getId())
                            msg.setTimeAgo(timeAgo: "Just now")
                            
                            items.append(msg)
                            
                            send(addToTable: false);
                        }
                    }
                    
                    self.messageText = ""
                    self.messageImage = false
                    self.messageEditView.text = ""
                    
                    self.tableView.reloadData()
                    
                    self.showContentScreen()
                    
                    self.view.endEditing(true)
                    
                    let numberOfSections = self.tableView.numberOfSections
                    let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
                    
                    let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
                    self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
                    
                    self.tableView.reloadData()
                }
            }
        
        return false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vw = UIView()
//        vw.backgroundColor = UIColor.red
        
        vw.isUserInteractionEnabled = false
        
        return vw
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var message: Message;
        
        message = items[indexPath.row];
        
        if (iApp.sharedInstance.getId() == message.getFromUserId()) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            
            cell.messageView.text = message.getText()
            
            if (message.getSeenAt() > 0) {
                
                cell.timeAgo.text = message.getTimeAgo() + " | " + NSLocalizedString("label_seen", comment: "")
                
            } else {
                
                cell.timeAgo.text = message.getTimeAgo()
            }
            
            if (message.getImgUrl().count == 0) {
                
                cell.pictureView.isHidden = true
                
                cell.pictureTop.constant = 0
                cell.pictureHeight.constant = 0
                
            } else {
                
                cell.pictureView.isHidden = false
                cell.pictureView.clipsToBounds = true
                
                if (iApp.sharedInstance.getCache().object(forKey: message.getImgUrl() as AnyObject) != nil) {
                    
                    cell.pictureView.image = iApp.sharedInstance.getCache().object(forKey: message.getImgUrl() as AnyObject) as? UIImage
                    
                } else {
                    
                    if (!message.imgLoading) {
                        
                        message.imgLoading = true;
                        
                        let imageUrlString = message.getImgUrl()
                        let imageUrl:URL = URL(string: imageUrlString)!
                        
                        DispatchQueue.global().async {
                            
                            let data = try? Data(contentsOf: imageUrl)
                            
                            DispatchQueue.main.async {
                                
                                if data != nil {
                                    
                                    let img = UIImage(data: data!)
                                    
                                    cell.pictureView.image = img
                                    
                                    iApp.sharedInstance.getCache().setObject(img!, forKey: message.getImgUrl() as AnyObject)
                                    
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        
                    }
                }
            }
            
            return cell
            
        } else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
            
            if (message.getText().count > 0) {
            
                cell.messageView.text = message.getText()
                
            } else {
                
                cell.messageView.text = message.getFullname()
            }
            
            cell.timeAgo.text = message.getTimeAgo()
            
            // message image
            
            if (message.getImgUrl().count == 0) {
                
                cell.pictureView.isHidden = true
                
                cell.pictureTop.constant = 0
                cell.pictureHeight.constant = 0
                
            } else {
                
                cell.pictureView.isHidden = false
                cell.pictureView.clipsToBounds = true
                
                if (iApp.sharedInstance.getCache().object(forKey: message.getImgUrl() as AnyObject) != nil) {
                    
                    cell.pictureView.image = iApp.sharedInstance.getCache().object(forKey: message.getImgUrl() as AnyObject) as? UIImage
                    
                } else {
                    
                    if (!message.imgLoading) {
                        
                        message.imgLoading = true;
                        
                        let imageUrlString = message.getImgUrl()
                        let imageUrl:URL = URL(string: imageUrlString)!
                        
                        DispatchQueue.global().async {
                            
                            let data = try? Data(contentsOf: imageUrl)
                            
                            DispatchQueue.main.async {
                                
                                if data != nil {
                                    
                                    let img = UIImage(data: data!)
                                    
                                    cell.pictureView.image = img
                                    
                                    iApp.sharedInstance.getCache().setObject(img!, forKey: message.getImgUrl() as AnyObject)
                                    
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        
                    }
                }
            }
            
            // User fhoto
            
            cell.photoView.layer.borderWidth = 1
            cell.photoView.layer.masksToBounds = false
            cell.photoView.layer.borderColor = UIColor.lightGray.cgColor
            cell.photoView.layer.cornerRadius = cell.photoView.frame.height/2
            cell.photoView.clipsToBounds = true
            
            if (message.getPhotoUrl().count == 0) {
                
                cell.photoView.image = UIImage(named: "ic_profile_default_photo")
                
            } else {
                
                if (iApp.sharedInstance.getCache().object(forKey: message.getPhotoUrl() as AnyObject) != nil) {
                    
                    cell.photoView.image = iApp.sharedInstance.getCache().object(forKey: message.getPhotoUrl() as AnyObject) as? UIImage
                    
                } else {
                    
                    if (!message.photoLoading) {
                        
                        message.photoLoading = true;
                        
                        let imageUrlString = message.getPhotoUrl()
                        let imageUrl:URL = URL(string: imageUrlString)!
                        
                        DispatchQueue.global().async {
                            
                            let data = try? Data(contentsOf: imageUrl)
                            
                            DispatchQueue.main.async {
                                
                                if data != nil {
                                    
                                    let img = UIImage(data: data!)
                                    
                                    cell.photoView.image = img
                                    
                                    iApp.sharedInstance.getCache().setObject(img!, forKey: message.getPhotoUrl() as AnyObject)
                                    
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        
                    }
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func send(addToTable: Bool) {
        
        if (iApp.sharedInstance.getPro() == 0 && iApp.sharedInstance.getFreeMessagesCount() > 0) {
            
            iApp.sharedInstance.setFreeMessagesCount(freeMessagesCount: iApp.sharedInstance.getFreeMessagesCount() - 1)
        }
        
        print("Pro: \(iApp.sharedInstance.getPro())")
        print("Free Messages Count: \(iApp.sharedInstance.getFreeMessagesCount())")
        
        var request = URLRequest(url: URL(string: Constants.METHOD_MESSAGE_NEW)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=\(String(Constants.CLIENT_ID))&accountId=\(String(iApp.sharedInstance.getId()))&accessToken=\(iApp.sharedInstance.getAccessToken())&chatFromUserId=\(String(self.chatFromUserId))&chatToUserId=\(String(self.chatToUserId))&chatId=\(String(self.chatId))&messageText=" + self.messageSendText + "&messageImg=\(self.messageImgUrl)&profileId=\(String(self.profileId))&listId=\(String(0))&stickerId=\(self.stickerId)&stickerImgUrl=\(self.stickerImg)";
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.serverRequestEnd();
                })
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        //Get chatId
                        self.chatId = (response["chatId"] as AnyObject).integerValue
                        iApp.sharedInstance.setCurrentChatId(chatId: self.chatId)
                        
                        //Get itemId
                        self.itemId = (response["msgId"] as AnyObject).integerValue
                        
                        if (addToTable) {
                            
                            self.items.append(Message(Response: response["message"] as AnyObject))
                            
                            print(response)
                        }
                        
                        self.itemsCount = self.itemsCount + 1;
                        
                        self.messageImage = false
                        self.messageImgUrl = ""
                        self.messageSendText = ""
                        self.stickerImg = ""
                        self.stickerId = 0
                    
                    } else {
                        
                        let error_code = (response["error_code"] as AnyObject).integerValue
                        
                        if (error_code == Constants.ERROR_OTP_VERIFICATION) {
                            
                            self.showMessagePrompt(msg: NSLocalizedString("otp_verification_promo", comment: ""));
                        }
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.choiceImage.image = UIImage(named: "ic_action_icon")
                        
                        self.serverRequestEnd();
                        
                        self.loadingComplete()
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd();
                    })
                }
            }
            
        }).resume();
    }
    
    func getPrevious() {
        
        self.loadMoreButton.isEnabled = false
        
        var request = URLRequest(url: URL(string: Constants.METHOD_CHAT_GET_PREVIOUS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&profileId=" + String(self.profileId) + "&msgId=" + String(self.itemId) + "&chatId=" + String(self.chatId);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                self.loadMoreButton.isEnabled = true
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        //Get itemId
                        self.itemId = (response["msgId"] as AnyObject).integerValue
                        
                        //Get items array
                        let itemsArray = response["messages"] as! [AnyObject]
                        
                        //Read items from array
                        for itemObj in itemsArray {
                            
                            //add item to adapter(array). insert to start | append to 0 index
                            
                            self.items.insert(Message(Response: itemObj), at: 0)
                        }
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.loadingComplete()
                        
                        self.loadMoreButton.isEnabled = true
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    self.loadMoreButton.isEnabled = true
                }
            }
            
        }).resume();
    }
    
    func sendNotify(notify: Int) {
        
        var request = URLRequest(url: URL(string: Constants.METHOD_CHAT_NOTIFY)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&chatFromUserId=" + String(self.chatFromUserId) + "&chatToUserId=" + String(self.chatToUserId) + "&chatId=" + String(self.chatId) + "&notifyId=" + String(notify) + "&android_fcm_regId=" + (self.with_android_fcm_regid) + "&ios_fcm_regId=" + (self.with_ios_fcm_regid);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        self.chatUpdate = true
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                }
            }
            
        }).resume();
    }
    
    func update() {
        
        var request = URLRequest(url: URL(string: Constants.METHOD_CHAT_UPDATE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&chatFromUserId=" + String(self.chatFromUserId) + "&chatToUserId=" + String(self.chatToUserId) + "&chatId=" + String(self.chatId) + "&freeMessagesCount=" + String(iApp.sharedInstance.getFreeMessagesCount());
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        self.chatUpdate = true
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                }
            }
            
        }).resume();
    }
    
    func uploadImage() {
        
        let myUrl = NSURL(string: Constants.METHOD_MESSAGE_UPLOAD_IMAGE);
        
        let imageData = Helper.rotateImage(image: self.choiceImage.image!).jpeg(.low)
        
        if (imageData == nil) {
            
            return;
        }
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = ["accountId" : String(iApp.sharedInstance.getId()), "accessToken" : iApp.sharedInstance.getAccessToken()]
        
        let boundary = Helper.generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = Helper.createBodyWithParameters(parameters: param, filePathKey: "uploaded_file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        serverRequestStart()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            
            data, response, error in
            
            if error != nil {
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
                return
            }
            
            do {
                
                let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                let responseError = response["error"] as! Bool;
                
                print(response)
                
                if (responseError == false) {
                    
                    self.messageImgUrl = response["imgUrl"] as! String
                }
                
                DispatchQueue.main.async() {
                    
                    self.send(addToTable: true)
                }
                
            } catch {
                
                print(error)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
            }
            
        }
        
        task.resume()
    }
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }
    
    func showMessagePrompt(msg: String) {
        
        DispatchQueue.global(qos: .background).async {
            
            DispatchQueue.main.async {
                
                // show message with error
                
                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: msg, preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("otp_action_link_number", comment: ""), style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
                
                    self.performSegue(withIdentifier: "linkNumber", sender: self)})
                )
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func showLoadingScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
        
        self.tableView.isHidden = true
        
        self.messageEditView.isHidden = true
    }
    
    func showContentScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        
        self.tableView.isHidden = false
        
        self.messageEditView.isHidden = false
    }
    
    func showEmptyScreen() {
        
        self.textMessageView.text = NSLocalizedString("label_empty", comment: "");
        self.textMessageView.isHidden = false
        
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        
        self.tableView.isHidden = true
        
        self.messageEditView.isHidden = false
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
