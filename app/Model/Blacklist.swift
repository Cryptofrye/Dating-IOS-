//
//  Blacklist.swift
//
//  Created by Demyanchuk Dmitry on 26.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class Blacklist {
    
    public var photoLoading = false
    
    private var id: Int = 0
    private var blockedUserId: Int = 0
    private var blockedUserVerified: Int = 0
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    private var reason: String?

    private var timeAgo: String?
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        self.setBlockedUserId(blockedUserId: Int((Response["blockedUserId"] as? String)!)!)
        self.setBlockedUserVerified(blockedUserVerified: Int((Response["blockedUserVerify"] as? String)!)!)
        
        self.setFullname(fullname: (Response["blockedUserFullname"] as? String)!)
        self.setUsername(username: (Response["blockedUserUsername"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["blockedUserPhotoUrl"] as? String)!)
        self.setReason(reason: (Response["reason"] as? String)!)
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
    
    public func setBlockedUserId(blockedUserId: Int) {
        
        self.blockedUserId = blockedUserId;
    }
    
    func getBlockedUserId() -> Int {
        
        return self.blockedUserId;
    }
    
    public func setBlockedUserVerified(blockedUserVerified: Int) {
        
        self.blockedUserVerified = blockedUserVerified;
    }
    
    func getBlockedUserVerified() -> Int {
        
        return self.blockedUserVerified;
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
    
    public func setReason(reason: String) {
        
        self.reason = reason
    }
    
    public func getReason()->String {
        
        return self.reason!
    }
    
    public func setTimeAgo(timeAgo: String) {
        
        self.timeAgo = timeAgo
    }
    
    public func getTimeAgo()->String {
        
        return self.timeAgo!
    }
}
