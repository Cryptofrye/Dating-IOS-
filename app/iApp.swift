//
//  iApp.swift
//
//  Created by Mac Book on 01.01.2020.
//  Copyright © 2020 raccoonsquare@gmail.com All rights reserved.
//

import Foundation

class iApp {
    
    static let sharedInstance = iApp();
    
    var msg = Message()
    
    private var settings = iSettings()
    
    private var currentChatId = 0;
    
    private var id: Int = 0;
    
    private var access_token: String = "";
    
    // Facebook
    
    private var fbId: String = "";
    private var fbName: String = "";
    private var fbEmail: String = "";
    
    // Upgrades
    
    private var admob: Int = 0;
    private var ghost: Int = 0;
    private var pro: Int = 0;
    
    // Notifications
    
    private var allowLikesGCM: Int = 1;
    private var allowCommentsGCM: Int = 1;
    private var allowMessagesGCM: Int = 1;
    private var allowGiftsGCM: Int = 1;
    private var allowFollowersGCM: Int = 1;
    
    private var ios_fcm_regid = "";
    
    private var username: String = "";
    private var fullname: String = "";
    private var email: String = "";
    private var location: String = "";
    private var photoUrl: String = "";
    private var coverUrl: String = "";
    
    private var facebookPage: String = "";
    private var instagramPage: String = "";
    
    private var state: Int = 0;
    private var sex: Int = 0;
    private var verified: Int = 0;
    private var balance: Int = 0;
    private var email_verified: Int = 0;
    private var freeMessagesCount: Int = 0;
    
    private var year: Int = 0
    private var month: Int = 0
    private var day: Int = 0
    
    private var sex_orientation: Int = 0
    private var age: Int = 0
    private var height: Int = 0
    private var weight: Int = 0
    
    // Privacy settings
    
    private var allowMessages: Int = 0;
    private var allowGalleryComments: Int = 0;
    
    private var allowShowMyLikes: Int = 0;
    private var allowShowMyGifts: Int = 0;
    private var allowShowMyFriends: Int = 0;
    private var allowShowMyGallery: Int = 0;
    private var allowShowMyInfo: Int = 0;
    
    // For bages
    
    private var messagesCount: Int = 0;
    private var notificationsCount: Int = 0;
    private var newFriendsCount: Int = 0;
    private var guestsCount: Int = 0;
    
    // Dating App
    
    private var bio: String = "";
    
    private var relationshipStatus: Int = 0
    private var politicalViews: Int = 0
    private var worldViews: Int = 0
    private var personalPriority: Int = 0
    private var importantInOthers: Int = 0
    private var smokingViews: Int = 0
    private var alcoholViews: Int = 0
    private var lookingFor: Int = 0
    private var genderLike: Int = 0
    
    // OTP Verification
    
    private var otpVerified: Int = 0            // 0 = not verified, 1 = verified
    private var otpPhoneNumber: String = "";
    
    //
    
    private var cache: NSCache<AnyObject, AnyObject>!
    
    private init() {
        
        self.cache = NSCache()
    }
    
    public func getCache() -> NSCache<AnyObject, AnyObject> {
    
        return self.cache
    }
    
    // Settings
    
    public func getSettings() -> iSettings {
        
        return self.settings;
    }
    
    // Upgrades
    
    public func setPro(pro: Int) {
        
        self.pro = pro;
    }
    
    func getPro() -> Int {
        
        return self.pro;
    }
    
    public func setGhost(ghost: Int) {
        
        self.ghost = ghost;
    }
    
    func getGhost() -> Int {
        
        return self.ghost;
    }
    
    public func setAdmob(admob: Int) {
        
        self.admob = admob;
    }
    
    func getAdmob() -> Int {
        
        return self.admob;
    }
    
    // Notifications
    
    public func setAllowMessagesGCM(allowMessagesGCM: Int) {
        
        self.allowMessagesGCM = allowMessagesGCM;
    }
    
    func getAllowMessagesGCM() -> Int {
        
        return self.allowMessagesGCM;
    }
    
    public func setAllowLikesGCM(allowLikesGCM: Int) {
        
        self.allowLikesGCM = allowLikesGCM;
    }
    
    func getAllowLikesGCM() -> Int {
        
        return self.allowLikesGCM;
    }
    
    public func setAllowCommentsGCM(allowCommentsGCM: Int) {
        
        self.allowCommentsGCM = allowCommentsGCM;
    }
    
    func getAllowCommentsGCM() -> Int {
        
        return self.allowCommentsGCM;
    }
    
    public func setAllowFollowersGCM(allowFollowersGCM: Int) {
        
        self.allowFollowersGCM = allowFollowersGCM;
    }
    
    func getAllowFollowersGCM() -> Int {
        
        return self.allowFollowersGCM;
    }
    
    public func setAllowGiftsGCM(allowGiftsGCM: Int) {
        
        self.allowGiftsGCM = allowGiftsGCM;
    }
    
    func getAllowGiftsGCM() -> Int {
        
        return self.allowGiftsGCM;
    }
    
    // For bages
    
    public func setMessagesCount(messagesCount: Int) {
        
        self.messagesCount = messagesCount;
    }
    
    func getMessagesCount() -> Int {
        
        return self.messagesCount;
    }
    
    public func setNotificationsCount(notificationsCount: Int) {
        
        self.notificationsCount = notificationsCount;
    }
    
    func getNotificationsCount() -> Int {
        
        return self.notificationsCount;
    }
    
    public func setGuestsCount(guestsCount: Int) {
        
        self.guestsCount = guestsCount;
    }
    
    func getGuestsCount() -> Int {
        
        return self.guestsCount;
    }
    
    public func setNewFriendsCount(newFriendsCount: Int) {
        
        self.newFriendsCount = newFriendsCount;
    }
    
    func getNewFriendsCount() -> Int {
        
        return self.newFriendsCount;
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
    
    public func setBio(bio: String) {
        
        self.bio = bio;
    }
    
    func getBio() -> String {
        
        return self.bio;
    }
    
    
    public func setCurrentChatId(chatId: Int) {
        
        self.currentChatId = chatId;
    }
    
    public func getCurrentChatId()->Int {
        
        return self.currentChatId;
    }
    
    public func setId(id: Int) {
        
        self.id = id;
    }
    
    func getId() -> Int {
        
        return self.id;
    }
    
    public func setAccessToken(access_token: String) {
        
        self.access_token = access_token;
    }
    
    func getAccessToken() -> String {
        
        return self.access_token;
    }
    
    public func setFcmRegId(ios_fcm_regid: String) {
        
        self.ios_fcm_regid = ios_fcm_regid;
    }
    
    func getFcmRegId() -> String {
        
        return self.ios_fcm_regid;
    }
    
    public func setUsername(username: String) {
        
        self.username = username;
    }
    
    func getUsername() -> String {
        
        return self.username;
    }
    
    public func setFullname(fullname: String) {
        
        self.fullname = fullname;
    }
    
    func getFullname() -> String {
        
        return self.fullname;
    }
    
    public func setEmail(email: String) {
        
        self.email = email;
    }
    
    func getEmail() -> String {
        
        return self.email;
    }
    
    public func setLocation(location: String) {
        
        self.location = location;
    }
    
    func getLocation() -> String {
        
        return self.location;
    }
    
    public func setPhotoUrl(photoUrl: String) {
        
        self.photoUrl = photoUrl.replacingOccurrences(of: "/../", with: "/");
    }
    
    func getPhotoUrl() -> String {
        
        return self.photoUrl;
    }
    
    public func setCoverUrl(coverUrl: String) {
        
        self.coverUrl = coverUrl.replacingOccurrences(of: "/../", with: "/");
    }
    
    func getCoverUrl() -> String {
        
        return self.coverUrl;
    }
    
    public func setFacebookPage(facebookPage: String) {
        
        self.facebookPage = facebookPage;
    }
    
    func getFacebookPage() -> String {
        
        return self.facebookPage;
    }
    
    public func setInstagramPage(instagramPage: String) {
        
        self.instagramPage = instagramPage;
    }
    
    func getInstagramPage() -> String {
        
        return self.instagramPage;
    }
    
    public func setState(state: Int) {
        
        self.state = state;
    }
    
    func getState() -> Int {
        
        return self.state;
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
    
    public func setVerified(verified: Int) {
        
        self.verified = verified;
    }
    
    func getVerified() -> Int {
        
        return self.verified;
    }
    
    public func setBalance(balance: Int) {
        
        self.balance = balance;
    }
    
    func getBalance() -> Int {
        
        return self.balance;
    }
    
    public func setFreeMessagesCount(freeMessagesCount: Int) {
        
        self.freeMessagesCount = freeMessagesCount;
    }
    
    func getFreeMessagesCount() -> Int {
        
        return self.freeMessagesCount;
    }

    
    public func setEmailVerified(emailVerified: Int) {
        
        self.email_verified = emailVerified;
    }
    
    func getEmailVerified() -> Int {
        
        return self.email_verified;
    }
    
    public func setYear(year: Int) {
        
        self.year = year;
    }
    
    func getYear() -> Int {
        
        return self.year;
    }
    
    public func setMonth(month: Int) {
        
        self.month = month;
    }
    
    func getMonth() -> Int {
        
        return self.month;
    }
    
    public func setDay(day: Int) {
        
        self.day = day;
    }
    
    func getDay() -> Int {
        
        return self.day;
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
    
    public func setAllowMessages(allowMessages: Int) {
        
        self.allowMessages = allowMessages;
    }
    
    func getAllowMessages() -> Int {
        
        return self.allowMessages;
    }
    
    public func setAllowGalleryComments(allowGalleryComments: Int) {
        
        self.allowGalleryComments = allowGalleryComments;
    }
    
    func getAllowGalleryComments() -> Int {
        
        return self.allowGalleryComments;
    }
    
    // Facebook
    
    func setFacebookId(fbId: String) {
        
        self.fbId = fbId;
    }
    
    func getFacebookId() -> String {
        
        return self.fbId;
    }
    
    func setFacebookName(fbName: String) {
        
        self.fbName = fbName;
    }
    
    func getFacebookName() -> String {
        
        return self.fbName;
    }
    
    func setFacebookEmail(fbEmail: String) {
        
        self.fbEmail = fbEmail;
    }
    
    func getFacebookEmail() -> String {
        
        return self.fbEmail;
    }
    
    // OTP
    
    public func setOtpPhoneNumber(otpPhoneNumber: String) {
        
        self.otpPhoneNumber = otpPhoneNumber;
    }
    
    func getOtpPhoneNumber() -> String {
        
        return self.otpPhoneNumber;
    }
    
    public func setOtpVerified(otpVerified: Int) {
        
        self.otpVerified = otpVerified;
    }
    
    func getOtpVerified() -> Int {
        
        return self.otpVerified;
    }
    
    //
    
    func logout() {
        
        let defaults = UserDefaults.standard
        
        defaults.setValue(0, forKey: "id");
        defaults.setValue("", forKey: "access_token");
        defaults.setValue("", forKey: "username");
        defaults.setValue("", forKey: "fullname");
        defaults.setValue("", forKey: "email");
        
        iApp.sharedInstance.setId(id: 0);
        iApp.sharedInstance.setAccessToken(access_token: "");
        iApp.sharedInstance.setUsername(username: "");
        iApp.sharedInstance.setFullname(fullname: "");
        iApp.sharedInstance.setEmail(email: "");
        
        iApp.sharedInstance.setState(state: 0);
        
        defaults.synchronize()
    }
    
    func saveSettings() {
        
        let defaults = UserDefaults.standard
        
        defaults.setValue(self.getId(), forKey: "id");
        defaults.setValue(self.getAccessToken(), forKey: "access_token");
        
        defaults.setValue(self.getUsername(), forKey: "username");
        defaults.setValue(self.getFullname(), forKey: "fullname");
        defaults.setValue(self.getEmail(), forKey: "email");
        
        defaults.setValue(self.getAllowGiftsGCM(), forKey: "gifts_gcm");
        defaults.setValue(self.getAllowLikesGCM(), forKey: "likes_gcm");
        defaults.setValue(self.getAllowCommentsGCM(), forKey: "comments_gcm");
        defaults.setValue(self.getAllowMessagesGCM(), forKey: "messages_gcm");
        defaults.setValue(self.getAllowFollowersGCM(), forKey: "followers_gcm");
        
        defaults.setValue(self.getOtpVerified(), forKey: "otp_verified");
        defaults.setValue(self.getOtpPhoneNumber(), forKey: "otp_phone_number");
        
        defaults.synchronize();
    }
    
    func readSettings() {
        
        let defaults = UserDefaults.standard;
        
        if (defaults.object(forKey: "id") != nil) {
            
            self.setId(id: defaults.integer(forKey: "id"));
            self.setAccessToken(access_token: defaults.string(forKey: "access_token")!);
            
            self.setUsername(username: defaults.string(forKey: "username")!);
            self.setFullname(fullname: defaults.string(forKey: "fullname")!);
            self.setEmail(email: defaults.string(forKey: "email")!);
            
            iApp.sharedInstance.setAllowGiftsGCM(allowGiftsGCM: defaults.integer(forKey: "gifts_gcm"));
            iApp.sharedInstance.setAllowLikesGCM(allowLikesGCM: defaults.integer(forKey: "likes_gcm"));
            iApp.sharedInstance.setAllowCommentsGCM(allowCommentsGCM: defaults.integer(forKey: "comments_gcm"));
            iApp.sharedInstance.setAllowMessagesGCM(allowMessagesGCM: defaults.integer(forKey: "messages_gcm"));
            iApp.sharedInstance.setAllowFollowersGCM(allowFollowersGCM: defaults.integer(forKey: "followers_gcm"));
            
            if defaults.string(forKey: "otp_verified") != nil {
                
                iApp.sharedInstance.setOtpVerified(otpVerified: defaults.integer(forKey: "otp_verified"));
                iApp.sharedInstance.setOtpPhoneNumber(otpPhoneNumber: defaults.string(forKey: "otp_phone_number")!);
            }
            
        } else {
            
            print("No Id Key");
        }
        
        defaults.synchronize();
    }
    
    func authorize(Response : AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        self.setUsername(username: (Response["username"] as? String)!)
        self.setFullname(fullname: (Response["fullname"] as? String)!)
        self.setEmail(email: (Response["email"] as? String)!)
        self.setLocation(location: (Response["location"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["lowPhotoUrl"] as? String)!)
        self.setCoverUrl(coverUrl: (Response["coverUrl"] as? String)!)
        
        // Read Facebook Id
        self.setFacebookId(fbId: (Response["fb_id"]as? String)!)
        
        // Read Profile pages
        self.setFacebookPage(facebookPage: (Response["fb_page"] as? String)!)
        self.setInstagramPage(instagramPage: (Response["instagram_page"] as? String)!)
        
        self.setState(state: Int((Response["state"] as? String)!)!)
        self.setSex(sex: Int((Response["sex"] as? String)!)!)
        self.setVerified(verified: Int((Response["verify"] as? String)!)!)
        self.setBalance(balance: Int((Response["balance"] as? String)!)!)
        self.setFreeMessagesCount(freeMessagesCount: Int((Response["free_messages_count"] as? String)!)!)
        self.setEmailVerified(emailVerified: Int((Response["emailVerify"] as? String)!)!)
        
        self.setYear(year: Int((Response["year"] as? String)!)!)
        self.setMonth(month: Int((Response["month"] as? String)!)!)
        self.setDay(day: Int((Response["day"] as? String)!)!)
        
        self.setSexOrientation(sex_orientation: Int((Response["sex_orientation"] as? String)!)!)
        self.setAge(age: Int((Response["age"] as? String)!)!)
        self.setHeight(height: Int((Response["height"] as? String)!)!)
        self.setWeight(weight: Int((Response["weight"] as? String)!)!)
        
        self.setBio(bio: (Response["status"] as? String)!)
        
        // Upgrades
        
        self.setGhost(ghost: Int((Response["ghost"] as? String)!)!)
        self.setAdmob(admob: Int((Response["admob"] as? String)!)!)
        self.setPro(pro: Int((Response["pro"] as? String)!)!)
        
        // Push notifications | Notifications
        
//        self.setAllowMessagesGCM(allowMessagesGCM: Int((Response["allowMessagesGCM"] as? String)!)!)
//        self.setAllowLikesGCM(allowLikesGCM: Int((Response["allowLikesGCM"] as? String)!)!)
//        self.setAllowCommentsGCM(allowCommentsGCM: Int((Response["allowCommentsGCM"] as? String)!)!)
//        self.setAllowGiftsGCM(allowGiftsGCM: Int((Response["allowGiftsGCM"] as? String)!)!)
//        self.setAllowFollowersGCM(allowFollowersGCM: Int((Response["allowFollowersGCM"] as? String)!)!)
        
        // Privacy
        
        self.setAllowMessages(allowMessages: Int((Response["allowMessages"] as? String)!)!)
        self.setAllowGalleryComments(allowGalleryComments: Int((Response["allowPhotosComments"] as? String)!)!)
        
        self.setAllowShowMyLikes(allowShowMyLikes: Int((Response["allowShowMyLikes"] as? String)!)!)
        self.setAllowShowMyGifts(allowShowMyGifts: Int((Response["allowShowMyGifts"] as? String)!)!)
        self.setAllowShowMyFriends(allowShowMyFriends: Int((Response["allowShowMyFriends"] as? String)!)!)
        self.setAllowShowMyGallery(allowShowMyGallery: Int((Response["allowShowMyGallery"] as? String)!)!)
        self.setAllowShowMyInfo(allowShowMyInfo: Int((Response["allowShowMyInfo"] as? String)!)!)
        
        // Dating App
        
        self.setRelationshipStatus(relationshipStatus: Int((Response["iStatus"] as? String)!)!)
        self.setPoliticalViews(politicalViews: Int((Response["iPoliticalViews"] as? String)!)!)
        self.setWorldViews(worldViews: Int((Response["iWorldView"] as? String)!)!)
        self.setImportantInOthers(importantInOthers: Int((Response["iImportantInOthers"] as? String)!)!)
        self.setPersonalPriority(personalPriority: Int((Response["iPersonalPriority"] as? String)!)!)
        self.setSmokingViews(smokingViews: Int((Response["iSmokingViews"] as? String)!)!)
        self.setAlcoholViews(alcoholViews: Int((Response["iAlcoholViews"] as? String)!)!)
        self.setLookingFor(lookingFor: Int((Response["iLooking"] as? String)!)!)
        self.setGenderLike(genderLike: Int((Response["iInterested"] as? String)!)!)
        
        // Bages
        
//        self.setMessagesCount(messagesCount: (Response["messagesCount"] as? Int)!)
//        self.setNotificationsCount(notificationsCount: Int((Response["notificationsCount"] as? String)!)!)
//        self.setGuestsCount(guestsCount: Int((Response["guestsCount"] as? String)!)!)
//        self.setNewFriendsCount(newFriendsCount: Int((Response["newFriendsCount"] as? String)!)!)
        
        // for new version
        
        // self.setPhotoUrl(photoUrl: (Response["photoUrl"] as? String)!)
        // self.setCoverUrl(coverUrl: (Response["coverUrl"] as? String)!)
        // self.setVerified(verified: Int((Response["verified"] as? String)!)!)
        // self.setState(state: Int((Response["account_state"] as? String)!)!)
        // self.setEmailVerified(emailVerified: Int((Response["email_verified"] as? String)!)!)
        
        // OTP
        
        if (Response["otpVerified"] as? String != nil) {
         
            self.setOtpVerified(otpVerified: Int((Response["otpVerified"] as? String)!)!);
            self.setOtpPhoneNumber(otpPhoneNumber: (Response["otpPhone"] as? String)!);
        }
        
        // Save settings
        
        self.saveSettings();
    }
}
