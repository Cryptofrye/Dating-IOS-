//
//  Comment.swift
//
//  Created by Demyanchuk Dmitry on 17.07.20.
//  Copyright © 2020 qascript@mail.ru All rights reserved.
//

import UIKit

class Comment {
    
    public var photoLoading = false
    public var pictureLoading = false
    
    private var id: Int = 0
    
    private var itemId: Int = 0
    private var itemFromUserId: Int = 0
    
    public var owner = Profile();
    
    private var replyToUserId: Int = 0
    private var replyToUsername: String?
    private var replyToFullname: String?
    
    private var comment: String?
    private var imgUrl: String?
    
    private var timeAgo: String?
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        self.setItemId(itemId: Int((Response["itemId"] as? String)!)!)
        self.setItemFromUserId(itemFromUserId: Int((Response["itemFromUserId"] as? String)!)!)
        
        self.setOwner(owner: Profile(Response: (Response["owner"] as AnyObject)))
        
        self.setReplyToUserId(replyToUserId: Int((Response["replyToUserId"] as? String)!)!)
        self.setReplyToUsername(replyToUsername: (Response["replyToUserUsername"] as? String)!)
        self.setReplyToFullname(replyToFullname: (Response["replyToFullname"] as? String)!)
        
        self.setComment(comment: (Response["comment"] as? String)!)
        
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
    
    public func setItemFromUserId(itemFromUserId: Int) {
        
        self.itemFromUserId = itemFromUserId;
    }
    
    func getItemFromUserId() -> Int {
        
        return self.itemFromUserId;
    }
    
    public func setOwner(owner: Profile) {
        
        self.owner = owner;
    }
    
    func getOwner() -> Profile {
        
        return self.owner;
    }
    
    public func setComment(comment: String) {
        
        self.comment = comment
    }
    
    public func getComment()->String {
        
        return self.comment!
    }
    
    public func setImgUrl(imgUrl: String) {
        
        self.imgUrl = imgUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getImgUrl()->String {
        
        return self.imgUrl!
    }
    
    public func setTimeAgo(timeAgo: String) {
        
        self.timeAgo = timeAgo
    }
    
    public func getTimeAgo()->String {
        
        return self.timeAgo!
    }
    
    public func setReplyToUserId(replyToUserId: Int) {
        
        self.replyToUserId = replyToUserId;
    }
    
    func getReplyToUserId() -> Int {
        
        return self.replyToUserId;
    }
    
    public func setReplyToUsername(replyToUsername: String) {
        
        self.replyToUsername = replyToUsername
    }
    
    public func getReplyToUsername()->String {
        
        return self.replyToUsername!
    }
    
    public func setReplyToFullname(replyToFullname: String) {
        
        self.replyToFullname = replyToFullname
    }
    
    public func getReplyToFullname()->String {
        
        return self.replyToFullname!
    }
}
