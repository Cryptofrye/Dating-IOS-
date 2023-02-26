//
//  Notification.swift
//
//  Created by Demyanchuk Dmitry on 26.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class Notification {
    
    public var photoLoading = false
    
    private var id: Int = 0
    private var itemId: Int = 0
    private var type: Int = 0
    
    private var fromUserId: Int = 0
    private var fromUserState: Int = 0
    private var fromUserVerified: Int = 0
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    
    private var timeAgo: String?
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        self.setItemId(itemId: Int((Response["itemId"] as? String)!)!)
        self.setType(type: Int((Response["type"] as? String)!)!)
        
        if let fromId = Response["fromUserId"] as? String {

            self.setFromUserId(fromUserId: Int((fromId) )!)

        } else {

            self.setFromUserId(fromUserId: Response["fromUserId"] as! Int)
        }
        
        if let fromUserState = Response["fromUserState"] as? String {
            
            self.setFromUserState(fromUserState: Int((fromUserState) )!)
            
        } else {
            
            self.setFromUserState(fromUserState: Response["fromUserState"] as! Int)
        }
        
        self.setFromUserVerified(fromUserVerified: 0)
        
        self.setFullname(fullname: (Response["fromUserFullname"] as? String)!)
        self.setUsername(username: (Response["fromUserUsername"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["fromUserPhotoUrl"] as? String)!)
        self.setTimeAgo(timeAgo: (Response["timeAgo"] as? String)!)
        
    }
    
    init() {
        
    }
    
    public func setId(id: Int) {
        
        self.id = id;
    }
    
    func getId() -> Int {
        
        return self.id;
    }
    
    public func setItemId(itemId: Int) {
        
        self.itemId = itemId;
    }
    
    func getItemId() -> Int {
        
        return self.itemId;
    }
    
    public func setType(type: Int) {
        
        self.type = type;
    }
    
    func getType() -> Int {
        
        return self.type;
    }
    
    public func setFromUserId(fromUserId: Int) {
        
        self.fromUserId = fromUserId;
    }
    
    func getFromUserId() -> Int {
        
        return self.fromUserId;
    }
    
    public func setFromUserState(fromUserState: Int) {
        
        self.fromUserState = fromUserState;
    }
    
    func getFromUserState() -> Int {
        
        return self.fromUserState;
    }
    
    public func setFromUserVerified(fromUserVerified: Int) {
        
        self.fromUserVerified = fromUserVerified;
    }
    
    func getFromUserVerified() -> Int {
        
        return self.fromUserVerified;
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
}
