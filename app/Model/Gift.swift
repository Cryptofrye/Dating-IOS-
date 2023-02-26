//
//  Gift.swift
//
//  Created by Demyanchuk Dmitry on 27.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class Gift {
    
    public var photoLoading = false
    public var imgLoading = false
    
    private var id: Int = 0
    
    private var giftId: Int = 0
    private var giftAnonymous: Int = 0
    
    private var giftTo: Int = 0
    
    private var fromUserId: Int = 0
    private var fromUserVerified: Int = 0
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    
    private var message: String?
    private var imgUrl: String?
    
    private var date: String?
    private var timeAgo: String?
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        
        self.setGiftId(giftId: Int((Response["giftId"] as? String)!)!)
        self.setGiftAnonymous(giftAnonymous: Int((Response["giftAnonymous"] as? String)!)!)
        
        self.setGiftTo(giftTo: Int((Response["giftTo"] as? String)!)!)
        
        self.setFromUserId(fromUserId: Int((Response["giftFrom"] as? String)!)!)
        self.setFromUserVerified(fromUserVerified: Int((Response["giftFromUserVerify"] as? String)!)!)
        
        self.setFullname(fullname: (Response["giftFromUserFullname"] as? String)!)
        self.setUsername(username: (Response["giftFromUserUsername"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["giftFromUserPhoto"] as? String)!)
        
        self.setMessage(message: (Response["message"] as? String)!)
        self.setImgUrl(imgUrl: (Response["imgUrl"] as? String)!)
        
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
    
    public func setGiftId(giftId: Int) {
        
        self.giftId = giftId;
    }
    
    func getGiftId() -> Int {
        
        return self.giftId;
    }
    
    public func setGiftAnonymous(giftAnonymous: Int) {
        
        self.giftAnonymous = giftAnonymous;
    }
    
    func getGiftAnonymous() -> Int {
        
        return self.giftAnonymous;
    }

    public func setGiftTo(giftTo: Int) {
        
        self.giftTo = giftTo;
    }
    
    func getGiftTo() -> Int {
        
        return self.giftTo;
    }
    
    public func setFromUserId(fromUserId: Int) {
        
        self.fromUserId = fromUserId;
    }
    
    func getFromUserId() -> Int {
        
        return self.fromUserId;
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
    
    public func setMessage(message: String) {
        
        self.message = message
    }
    
    public func getMessage()->String {
        
        return self.message!
    }
    
    public func setImgUrl(imgUrl: String) {
        
        self.imgUrl = imgUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getImgUrl()->String {
        
        return self.imgUrl!
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
