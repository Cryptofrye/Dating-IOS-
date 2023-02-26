//
//  Notification.swift
//
//  Created by Demyanchuk Dmitry on 26.01.18.
//  Copyright © 2018 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class Dialog {
    
    public var photoLoading = false
    
    private var id: Int = 0
    
    private var toUserId: Int = 0
    private var fromUserId: Int = 0
    
    private var withUserId: Int = 0
    private var withUserState: Int = 0
    private var withUserVerified: Int = 0
    
    private var newMessagesCount: Int = 0
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    
    private var with_android_fcm_regid: String?
    private var with_ios_fcm_regid: String?
    
    private var lastMessage: String?
    private var lastMessageAgo: String?
    
    private var timeAgo: String?
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        self.setToUserId(toUserId: Int((Response["toUserId"] as? String)!)!)
        self.setFromUserId(fromUserId: Int((Response["fromUserId"] as? String)!)!)
        
        if let newMessagesCount = Response["newMessagesCount"] as? String {
            
            self.setNewMessagesCount(newMessagesCount: Int((newMessagesCount) )!)
            
        } else {
            
            self.setNewMessagesCount(newMessagesCount: Response["newMessagesCount"] as! Int)
        }
        
        self.setWithUserId(withUserId: Int((Response["withUserId"] as? String)!)!)
        self.setFromUserState(withUserState: Int((Response["withUserState"] as? String)!)!)
        self.setFromUserVerified(withUserVerified: 0)
        
        self.setFullname(fullname: (Response["withUserFullname"] as? String)!)
        self.setUsername(username: (Response["withUserUsername"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["withUserPhotoUrl"] as? String)!)
        self.setTimeAgo(timeAgo: (Response["timeAgo"] as? String)!)
        
        self.setLastMessage(lastMessage: (Response["lastMessage"] as? String)!)
        self.setLastMessageTimeAgo(lastMessageAgo: (Response["lastMessageAgo"] as? String)!)
        
        if let android_fcm_regId = Response["with_android_fcm_regId"] as? String {
            
            self.set_android_fcm_regId(android_fcm_regId: android_fcm_regId)
            
        } else {
            
            self.set_android_fcm_regId(android_fcm_regId: "")
        }
        
        if let ios_fcm_regid = Response["with_ios_fcm_regId"] as? String {
            
            self.set_ios_fcm_regId(ios_fcm_regId: ios_fcm_regid)
            
        } else {
            
            self.set_ios_fcm_regId(ios_fcm_regId: "")
        }
    }
    
    init() {
        
    }
    
    public func setId(id: Int) {
        
        self.id = id;
    }
    
    func getId() -> Int {
        
        return self.id;
    }
    
    public func setNewMessagesCount(newMessagesCount: Int) {
        
        self.newMessagesCount = newMessagesCount;
    }
    
    func getNewMessagesCount() -> Int {
        
        return self.newMessagesCount;
    }
    
    public func setFromUserId(fromUserId: Int) {
        
        self.fromUserId = fromUserId;
    }
    
    func getFromUserId() -> Int {
        
        return self.fromUserId;
    }
    
    public func setToUserId(toUserId: Int) {
        
        self.toUserId = toUserId;
    }
    
    func getToUserId() -> Int {
        
        return self.toUserId;
    }
    
    public func setWithUserId(withUserId: Int) {
        
        self.withUserId = withUserId;
    }
    
    func getWithUserId() -> Int {
        
        return self.withUserId;
    }
    
    public func setFromUserState(withUserState: Int) {
        
        self.withUserState = withUserState;
    }
    
    func getFromUserState() -> Int {
        
        return self.withUserState;
    }
    
    public func setFromUserVerified(withUserVerified: Int) {
        
        self.withUserVerified = withUserVerified;
    }
    
    func getFromUserVerified() -> Int {
        
        return self.withUserVerified;
    }
    
    public func setUsername(username: String) {
        
        self.username = username
    }
    
    public func getUsername()->String {
        
        return self.username!
    }
    
    public func setFullname(fullname: String) {
        
        self.fullname = fullname
    }
    
    public func getFullname()->String {
        
        return self.fullname!
    }
    
    public func setPhotoUrl(photoUrl: String) {
        
        self.photoUrl = photoUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getPhotoUrl()->String {
        
        return self.photoUrl!
    }
    
    public func setTimeAgo(timeAgo: String) {
        
        self.timeAgo = timeAgo
    }
    
    public func getTimeAgo()->String {
        
        return self.timeAgo!
    }
    
    public func setLastMessageTimeAgo(lastMessageAgo: String) {
        
        self.lastMessageAgo = lastMessageAgo
    }
    
    public func getLastMessageTimeAgo()->String {
        
        return self.lastMessageAgo!
    }
    
    public func setLastMessage(lastMessage: String) {
        
        self.lastMessage = lastMessage
    }
    
    public func getLastMessage()->String {
        
        return self.lastMessage!
    }
    
    public func set_android_fcm_regId(android_fcm_regId: String) {
        
        self.with_android_fcm_regid = android_fcm_regId
    }
    
    public func get_android_fcm_regId()->String {
        
        return self.with_android_fcm_regid!
    }
    
    public func set_ios_fcm_regId(ios_fcm_regId: String) {
        
        self.with_ios_fcm_regid = ios_fcm_regId
    }
    
    public func get_ios_fcm_regId()->String {
        
        return self.with_ios_fcm_regid!
    }
}
