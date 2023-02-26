//
//  Profile.swift
//
//  Created by Demyanchuk Dmitry on 02.01.1715
//  Copyright © 2018 raccoonsquare@gmail.com All rights reserved.
//s

import UIKit

class Profile {
    
    public var photoLoading = false
    
    private var id: Int = 0
    private var state: Int = 0
    
    private var friendsCount: Int = 0
    private var photosCount: Int = 0
    private var likesCount: Int = 0
    private var giftsCount: Int = 0
    
    private var sex: Int = 0
    
    private var sex_orientation: Int = 0
    private var age: Int = 0
    private var height: Int = 0
    private var weight: Int = 0
    
    private var distance: Double = 0.0
    
    private var username: String?
    private var fullname: String?
    private var photoUrl: String?
    private var coverUrl: String?
    
    private var verified: Int = 0
    
    // Privacy settings
    
    private var allowMessages: Int = 0
    private var allowPhotosComments: Int = 0
    
    private var allowShowMyLikes: Int = 0;
    private var allowShowMyGifts: Int = 0;
    private var allowShowMyFriends: Int = 0;
    private var allowShowMyGallery: Int = 0;
    private var allowShowMyInfo: Int = 0;
    
    private var blocked: Bool = false;
    private var myLike: Bool = false;
    private var follow: Bool = false;
    private var inBlackList: Bool = false;
    private var follower: Bool = false;
    private var friend: Bool = false;
    
    private var relationshipStatus: Int = 0
    private var politicalViews: Int = 0
    private var worldViews: Int = 0
    private var personalPriority: Int = 0
    private var importantInOthers: Int = 0
    private var smokingViews: Int = 0
    private var alcoholViews: Int = 0
    private var lookingFor: Int = 0
    private var genderLike: Int = 0
    
    private var authorizeTimeAgo: String?
    
    private var online: Bool = false;
    
    private var android_fcm_regid: String?
    private var ios_fcm_regid: String?
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        self.setState(state: Int((Response["state"] as? String)!)!)
        self.setVerified(verified: Int((Response["verify"] as? String)!)!)
    
        self.setSex(sex: Int((Response["sex"] as? String)!)!)
        
        self.setSexOrientation(sex_orientation: Int((Response["sex_orientation"] as? String)!)!)
        self.setAge(age: Int((Response["age"] as? String)!)!)
        self.setHeight(height: Int((Response["height"] as? String)!)!)
        self.setWeight(weight: Int((Response["weight"] as? String)!)!)
        
        self.setAllowMessages(allowMessages: Int((Response["allowMessages"] as? String)!)!)
        
        self.setFullname(fullname: (Response["fullname"] as? String)!)
        self.setUsername(username: (Response["username"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["lowPhotoUrl"] as? String)!)
        self.setCoverUrl(coverUrl: (Response["normalCoverUrl"] as? String)!)
        
        if let android_fcm_regId = Response["gcm_regid"] as? String {
            
            self.set_android_fcm_regId(android_fcm_regId: android_fcm_regId)
            
        } else {
            
            self.set_android_fcm_regId(android_fcm_regId: "")
        }
        
        if let ios_fcm_regid = Response["ios_fcm_regid"] as? String {
            
            self.set_ios_fcm_regId(ios_fcm_regId: ios_fcm_regid)
            
        } else {
            
            self.set_ios_fcm_regId(ios_fcm_regId: "")
        }
        
        if ((Response["distance"] as? Double) != nil) {
            
            self.setDistance(distance: Double((Response["distance"] as? Double)!))
        }
        
        // Privacy
        
        self.setAllowShowMyLikes(allowShowMyLikes: Int((Response["allowShowMyLikes"] as? String)!)!)
        self.setAllowShowMyGifts(allowShowMyGifts: Int((Response["allowShowMyGifts"] as? String)!)!)
        self.setAllowShowMyFriends(allowShowMyFriends: Int((Response["allowShowMyFriends"] as? String)!)!)
        self.setAllowShowMyGallery(allowShowMyGallery: Int((Response["allowShowMyGallery"] as? String)!)!)
        self.setAllowShowMyInfo(allowShowMyInfo: Int((Response["allowShowMyInfo"] as? String)!)!)
        
        // Dating App
        
        if ((Response["iStatus"] as? String) != nil) {
            
            self.setRelationshipStatus(relationshipStatus: Int((Response["iStatus"] as? String)!)!)
        }
        
        if ((Response["iPoliticalViews"] as? String) != nil) {
            
            self.setPoliticalViews(politicalViews: Int((Response["iPoliticalViews"] as? String)!)!)
        }
        
        if ((Response["iWorldView"] as? String) != nil) {
            
            self.setWorldViews(worldViews: Int((Response["iWorldView"] as? String)!)!)
        }
        
        if ((Response["iImportantInOthers"] as? String) != nil) {
            
            self.setImportantInOthers(importantInOthers: Int((Response["iImportantInOthers"] as? String)!)!)
        }
        
        if ((Response["iPersonalPriority"] as? String) != nil) {
            
            self.setPersonalPriority(personalPriority: Int((Response["iPersonalPriority"] as? String)!)!)
        }
        
        if ((Response["iSmokingViews"] as? String) != nil) {
            
            self.setSmokingViews(smokingViews: Int((Response["iSmokingViews"] as? String)!)!)
        }
        
        if ((Response["iAlcoholViews"] as? String) != nil) {
            
            self.setAlcoholViews(alcoholViews: Int((Response["iAlcoholViews"] as? String)!)!)
        }
        
        if ((Response["iLooking"] as? String) != nil) {
            
            self.setLookingFor(lookingFor: Int((Response["iLooking"] as? String)!)!)
        }
        
        if ((Response["iInterested"] as? String) != nil) {
            
            self.setGenderLike(genderLike: Int((Response["iInterested"] as? String)!)!)
        }
        
        
        if ((Response["allowPhotosComments"] as? Int) != nil) {
            
            self.setAllowPhotosComments(allowPhotosComments: Int((Response["allowPhotosComments"] as? String)!)!)
        }
        
        if ((Response["giftsCount"] as? String) != nil) {
            
            self.setGiftsCount(giftsCount: Int((Response["giftsCount"] as? String)!)!)
        }
        
        if ((Response["likesCount"] as? String) != nil) {
            
            self.setLikesCount(likesCount: Int((Response["likesCount"] as? String)!)!)
        }
        
        if ((Response["photosCount"] as? String) != nil) {
            
            self.setPhotosCount(photosCount: Int((Response["photosCount"] as? String)!)!)
        }
        
        if ((Response["friendsCount"] as? String) != nil) {
            
            self.setFriendsCount(friendsCount: Int((Response["friendsCount"] as? String)!)!)
        }
        
        
        
        if ((Response["blocked"] as? Bool) != nil) {
            
            self.setBlocked(blocked: (Response["blocked"] as? Bool)!)
        }
        
        if ((Response["myLike"] as? Bool) != nil) {
            
            self.setMyLike(myLike: (Response["myLike"] as? Bool)!)
        }
        
        if ((Response["follow"] as? Bool) != nil) {
            
            self.setFollow(follow: (Response["follow"] as? Bool)!)
        }
        
        if ((Response["follower"] as? Bool) != nil) {
            
            self.setFollower(follower: (Response["follower"] as? Bool)!)
        }
        
        if ((Response["friend"] as? Bool) != nil) {
            
            self.setFriend(friend: (Response["friend"] as? Bool)!)
        }
        
        if ((Response["inBlackList"] as? Bool) != nil) {
            
            self.setInBlackList(inBlackList: (Response["inBlackList"] as? Bool)!)
        }
        
        
        if ((Response["online"] as? Bool) != nil) {
            
            self.setOnline(online: (Response["online"] as? Bool)!)
        }
        
        self.setAuthorizeTimeAgo(authorizeTimeAgo: (Response["lastAuthorizeTimeAgo"] as? String)!)
        
        // for new version
        
        // self.setPhotoUrl(photoUrl: (Response["photoUrl"] as? String)!)
        // self.setCoverUrl(coverUrl: (Response["coverUrl"] as? String)!)
        // self.setVerified(verified: Int((Response["verified"] as? String)!)!)
    }
    
    init() {
    
        
    }
    
    
    // Privacy
    
    public func setAllowShowMyLikes(allowShowMyLikes: Int) {
        
        self.allowShowMyLikes = allowShowMyLikes;
    }
    
    func getAllowShowMyLikes() -> Int {
        
        return self.allowShowMyLikes;
    }
    
    public func setAllowShowMyGifts(allowShowMyGifts: Int) {
        
        self.allowShowMyGifts = allowShowMyGifts;
    }
    
    func getAllowShowMyGifts() -> Int {
        
        return self.allowShowMyGifts;
    }
    
    public func setAllowShowMyFriends(allowShowMyFriends: Int) {
        
        self.allowShowMyFriends = allowShowMyFriends;
    }
    
    func getAllowShowMyFriends() -> Int {
        
        return self.allowShowMyFriends;
    }
    
    public func setAllowShowMyGallery(allowShowMyGallery: Int) {
        
        self.allowShowMyGallery = allowShowMyGallery;
    }
    
    func getAllowShowMyGallery() -> Int {
        
        return self.allowShowMyGallery;
    }
    
    public func setAllowShowMyInfo(allowShowMyInfo: Int) {
        
        self.allowShowMyInfo = allowShowMyInfo;
    }
    
    func getAllowShowMyInfo() -> Int {
        
        return self.allowShowMyInfo;
    }
    
    public func set_android_fcm_regId(android_fcm_regId: String) {
        
        self.android_fcm_regid = android_fcm_regId
    }
    
    public func get_android_fcm_regId()->String {
        
        return self.android_fcm_regid!
    }
    
    public func set_ios_fcm_regId(ios_fcm_regId: String) {
        
        self.ios_fcm_regid = ios_fcm_regId
    }
    
    public func get_ios_fcm_regId()->String {
        
        return self.ios_fcm_regid!
    }
    

    // Dating App
    
    public func setRelationshipStatus(relationshipStatus: Int) {
        
        self.relationshipStatus = relationshipStatus;
    }
    
    func getRelationshipStatus() -> Int {
        
        return self.relationshipStatus;
    }
    
    
    public func setPoliticalViews(politicalViews: Int) {
        
        self.politicalViews = politicalViews;
    }
    
    func getPoliticalViews() -> Int {
        
        return self.politicalViews;
    }
    
    
    public func setWorldViews(worldViews: Int) {
        
        self.worldViews = worldViews;
    }
    
    func getWorldViews() -> Int {
        
        return self.worldViews;
    }
    
    public func setImportantInOthers(importantInOthers: Int) {
        
        self.importantInOthers = importantInOthers;
    }
    
    func getImportantInOthers() -> Int {
        
        return self.importantInOthers;
    }
    
    public func setPersonalPriority(personalPriority: Int) {
        
        self.personalPriority = personalPriority;
    }
    
    func getPersonalPriority() -> Int {
        
        return self.personalPriority;
    }
    
    public func setSmokingViews(smokingViews: Int) {
        
        self.smokingViews = smokingViews;
    }
    
    func getSmokingViews() -> Int {
        
        return self.smokingViews;
    }
    
    public func setAlcoholViews(alcoholViews: Int) {
        
        self.alcoholViews = alcoholViews;
    }
    
    func getAlcoholViews() -> Int {
        
        return self.alcoholViews;
    }
    
    public func setLookingFor(lookingFor: Int) {
        
        self.lookingFor = lookingFor;
    }
    
    func getLookingFor() -> Int {
        
        return self.lookingFor;
    }
    
    public func setGenderLike(genderLike: Int) {
        
        self.genderLike = genderLike;
    }
    
    func getGenderLike() -> Int {
        
        return self.genderLike;
    }
    
    
    
    public func setBlocked(blocked: Bool) {
        
        self.blocked = blocked;
    }
    
    func isBlocked() -> Bool {
        
        return self.blocked;
    }

    public func setMyLike(myLike: Bool) {
        
        self.myLike = myLike;
    }
    
    func isMyLike() -> Bool {
        
        return self.myLike;
    }
    
    public func setFollow(follow: Bool) {
        
        self.follow = follow;
    }
    
    func isFollow() -> Bool {
        
        return self.follow;
    }
    
    public func setInBlackList(inBlackList: Bool) {
        
        self.inBlackList = inBlackList;
    }
    
    func isInBlackList() -> Bool {
        
        return self.inBlackList;
    }
    
    public func setFriend(friend: Bool) {
        
        self.friend = friend;
    }
    
    func isFriend() -> Bool {
        
        return self.friend;
    }
    
    public func setFollower(follower: Bool) {
        
        self.follower = follower;
    }
    
    func isFollower() -> Bool {
        
        return self.follower;
    }
    
    public func setGiftsCount(giftsCount: Int) {
        
        self.giftsCount = giftsCount;
    }
    
    func getGiftsCount() -> Int {
        
        return self.giftsCount;
    }
    
    public func setLikesCount(likesCount: Int) {
        
        self.likesCount = likesCount;
    }
    
    func getLikesCount() -> Int {
        
        return self.likesCount;
    }
    
    public func setPhotosCount(photosCount: Int) {
        
        self.photosCount = photosCount;
    }
    
    func getPhotosCount() -> Int {
        
        return self.photosCount;
    }
    
    public func setFriendsCount(friendsCount: Int) {
        
        self.friendsCount = friendsCount;
    }
    
    func getFriendsCount() -> Int {
        
        return self.friendsCount;
    }
    
    
    
    
    //
    
    public func setOnline(online: Bool) {
        
        self.online = online;
    }
    
    func isOnline() -> Bool {
        
        return self.online;
    }
    
    public func setAuthorizeTimeAgo(authorizeTimeAgo: String) {
        
        self.authorizeTimeAgo = authorizeTimeAgo
    }
    
    public func getAuthorizeTimeAgo()->String {
        
        return self.authorizeTimeAgo!
    }
    
    public func setDistance(distance: Double) {
        
        self.distance = distance;
    }
    
    func getDistance() -> Double {
        
        return self.distance;
    }
    
    
    public func setId(id: Int) {
        
        self.id = id;
    }
    
    func getId() -> Int {
        
        return self.id;
    }
    
    public func setState(state: Int) {
        
        self.state = state;
    }
    
    func getState() -> Int {
        
        return self.state;
    }
    
    public func setVerified(verified: Int) {
        
        self.verified = verified;
    }
    
    func getVerified() -> Int {
        
        return self.verified;
    }
    
    public func setSex(sex: Int) {
        
        self.sex = sex;
    }
    
    func getSex() -> Int {
        
        return self.sex;
    }
    
    public func setSexOrientation(sex_orientation: Int) {
        
        self.sex_orientation = sex_orientation;
    }
    
    func getSexOrientation() -> Int {
        
        return self.sex_orientation;
    }
    
    public func setAge(age: Int) {
        
        self.age = age;
    }
    
    func getAge() -> Int {
        
        return self.age;
    }
    
    public func setWeight(weight: Int) {
        
        self.weight = weight;
    }
    
    func getWeight() -> Int {
        
        return self.weight;
    }
    
    public func setHeight(height: Int) {
        
        self.height = height;
    }
    
    func getHeight() -> Int {
        
        return self.height;
    }
    
    public func setAllowMessages(allowMessages: Int) {
        
        self.allowMessages = allowMessages;
    }
    
    func getAllowMessages() -> Int {
        
        return self.allowMessages;
    }
    
    public func setAllowPhotosComments(allowPhotosComments: Int) {
        
        self.allowPhotosComments = allowPhotosComments;
    }
    
    func getAllowPhotosComments() -> Int {
        
        return self.allowPhotosComments;
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
    
    public func setCoverUrl(coverUrl: String) {
        
        self.coverUrl = coverUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getCoverUrl()->String {
        
        return self.coverUrl!
    }
    
    
}
