//
//  Message.swift
//
//  Created by Demyanchuk Dmitry on 04.01.18.
//  Copyright © 2018 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class Message {
    
    public var photoLoading = false
    public var imgLoading = false
    
    private var id: Int = 0
    private var fromUserId: Int = 0
    private var fromUserVerified: Int = 0
    private var seenAt: Int = 0
    
    private var stickerId: Int = 0
    private var stickerImgUrl: String?
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    private var text: String?
    private var imgUrl: String?
    private var date: String?
    private var timeAgo: String?
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        
        if let fromId = Response["fromUserId"] as? String {
            
            self.setFromUserId(fromUserId: Int((fromId) )!)
            
        } else {
            
            self.setFromUserId(fromUserId: Response["fromUserId"] as! Int)
        }
        
        
        self.setFromUserVerified(fromUserVerified: Int((Response["fromUserVerify"] as? String)!)!)
        
        if let sticker = Response["stickerId"] as? String {
            
            self.setStickerId(stickerId: Int((sticker) )!)
            
        } else {
            
            self.setStickerId(stickerId: Response["stickerId"] as! Int)
        }
        
        self.setStickerImgUrl(stickerImgUrl: (Response["stickerImgUrl"] as? String)!)
        
        if let seen = Response["seenAt"] as? String {
            
            self.setSeenAt(seenAt: Int((seen) )!)
            
        } else {
            
            self.setSeenAt(seenAt: Response["seenAt"] as! Int)
        }
        
        self.setFullname(fullname: (Response["fromUserFullname"] as? String)!)
        self.setUsername(username: (Response["fromUserUsername"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["fromUserPhotoUrl"] as? String)!)
        self.setText(text: (Response["message"] as? String)!)
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
    
    public func setSeenAt(seenAt: Int) {
        
        self.seenAt = seenAt;
    }
    
    func getSeenAt() -> Int {
        
        return self.seenAt;
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
    
    public func setText(text: String) {
        
        self.text = text
    }
    
    public func getText()->String {
        
        return self.text!
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
    
    public func setStickerId(stickerId: Int) {
        
        self.stickerId = stickerId;
    }
    
    func getStickerId() -> Int {
        
        return self.stickerId;
    }
    
    public func setStickerImgUrl(stickerImgUrl: String) {
        
        self.stickerImgUrl = stickerImgUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getStickerImgUrl()->String {
        
        return self.stickerImgUrl!
    }
}
