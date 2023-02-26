//
//  Guest.swift
//
//  Created by Demyanchuk Dmitry on 01.02.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class Guest {

    public var photoLoading = false
    
    private var id: Int = 0
    
    private var guestUserId: Int = 0
    private var guestUserVerified: Int = 0
    
    private var guestTo: Int = 0
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    
    private var date: String?
    private var timeAgo: String?
    
    private var times: Int = 0
    
    private var online: Bool = false
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        self.setGuestUserId(guestUserId: Int((Response["guestUserId"] as? String)!)!)
        self.setGuestUserVerified(guestUserVerified: Int((Response["guestUserVerify"] as? String)!)!)
        self.setGuestTo(guestTo: Int((Response["guestTo"] as? String)!)!)
        
        self.setFullname(fullname: (Response["guestUserFullname"] as? String)!)
        self.setUsername(username: (Response["guestUserUsername"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["guestUserPhoto"] as? String)!)
        
        self.setOnline(online: (Response["guestUserOnline"] as? Bool)!)
        
        self.setDate(date: (Response["date"] as? String)!)
        self.setTimeAgo(timeAgo: (Response["timeAgo"] as? String)!)
        
        self.setTimes(times: Int((Response["times"] as? String)!)!)
        
    }
    
    init() {
        
    }
    
    public func setId(id: Int) {
        
        self.id = id;
    }
    
    func getId() -> Int {
        
        return self.id;
    }
    
    public func setGuestUserId(guestUserId: Int) {
        
        self.guestUserId = guestUserId;
    }
    
    func getGuestUserId() -> Int {
        
        return self.guestUserId;
    }
    
    public func setGuestUserVerified(guestUserVerified: Int) {
        
        self.guestUserVerified = guestUserVerified;
    }
    
    func getGuestUserVerified() -> Int {
        
        return self.guestUserVerified;
    }
    
    public func setGuestTo(guestTo: Int) {
        
        self.guestTo = guestTo;
    }
    
    func getGuestTo() -> Int {
        
        return self.guestTo;
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
    
    public func setTimes(times: Int) {
        
        self.times = times;
    }
    
    func getTimes() -> Int {
        
        return self.times;
    }
}
