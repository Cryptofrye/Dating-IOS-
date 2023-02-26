//
//  Friend.swift
//
//  Created by Demyanchuk Dmitry on 27.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class Friend {
    
    public var photoLoading = false
    
    private var id: Int = 0
    
    private var friendUserId: Int = 0
    private var friendUserVerified: Int = 0
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    private var location: String?
    private var date: String?
    private var timeAgo: String?
    
    private var online: Bool = false
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        self.setFriendUserId(friendUserId: Int((Response["friendUserId"] as? String)!)!)
        self.setFriendUserVerified(friendUserVerified: Int((Response["friendUserVerify"] as? String)!)!)
        
        self.setFullname(fullname: (Response["friendUserFullname"] as? String)!)
        self.setUsername(username: (Response["friendUserUsername"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["friendUserPhoto"] as? String)!)
        self.setLocation(location: (Response["friendLocation"] as? String)!)
        
        self.setOnline(online: (Response["friendUserOnline"] as? Bool)!)
        
        self.setDate(date: (Response["date"] as? String)!)
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
    
    public func setFriendUserId(friendUserId: Int) {
        
        self.friendUserId = friendUserId;
    }
    
    func getFriendUserId() -> Int {
        
        return self.friendUserId;
    }
    
    public func setFriendUserVerified(friendUserVerified: Int) {
        
        self.friendUserVerified = friendUserVerified;
    }
    
    func getFriendUserVerified() -> Int {
        
        return self.friendUserVerified;
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
    
    public func setLocation(location: String) {
        
        self.location = location
    }
    
    public func getLocation()->String {
        
        return self.location!
    }
    
    public func setOnline(online: Bool) {
        
        self.online = online
    }
    
    public func isOnline()->Bool {
        
        return self.online
    }
    
    public func setDate(date: String) {
        
        self.date = date
    }
    
    public func getDate()->String {
        
        return self.date!
    }
    
    public func setTimeAgo(timeAgo: String) {
        
        self.timeAgo = timeAgo
    }
    
    public func getTimeAgo()->String {
        
        return self.timeAgo!
    }
}
