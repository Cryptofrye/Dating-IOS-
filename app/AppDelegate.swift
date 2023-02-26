//
//  AppDelegate.swift
//
//  Created by Demyanchuk Dmitry on 11.07.21.
//  Copyright © 2021 raccoonsquare@gmail.com All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging

import UserNotifications

import Firebase

import FacebookCore
import FacebookLogin
import FBSDKLoginKit

import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure();
        
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            
            // [START set_messaging_delegate]
            Messaging.messaging().delegate = self
            
            // [END set_messaging_delegate]
            // Register for remote notifications. This shows a permission dialog on first run, to
            // show the dialog at a more appropriate time move this registration accordingly.
            // [START register_for_notifications]
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
            } else {
                
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
        
            
            application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        return ApplicationDelegate.shared.application(app, open: url, options: options)
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        //         Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        print("didReceiveRemoteNotification 1")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        //        Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        //print("Background Message ID: \(userInfo["gcm.message_id"]!)")
        
        print(userInfo)
        print("didReceiveRemoteNotification 2")
        
        handleNorification(userInfo: userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
        
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        //        Messaging.messaging().apnsToken = deviceToken
    }
    
    func handleNorification(userInfo:[AnyHashable:Any]){
        
        if let remoteMessage = userInfo as? [String:Any]{
            
            if let type = remoteMessage["type"] as? NSString {
                
                print(type)
                
                let mType = Int((type) as String)!
                
                let accountId = remoteMessage["accountId"] as? NSString
                
                let mAccountId = Int((accountId)! as String)!
                
                switch mType {
                    
                case Constants.GCM_NOTIFY_FOLLOWER:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        
                        if (iApp.sharedInstance.getAllowFollowersGCM() == 1) {
                            
                            createNotify(id: "follower", title: NSLocalizedString("label_new_follower_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_follower", comment: ""))
                        }
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_MESSAGE:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        let mChatId = Int((remoteMessage["id"] as? NSString)! as String)!
                        
                        if (iApp.sharedInstance.getCurrentChatId() != mChatId) {
                            
                            if (iApp.sharedInstance.getMessagesCount() == 0) {
                                
                                iApp.sharedInstance.setMessagesCount(messagesCount: iApp.sharedInstance.getMessagesCount() + 1)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                            }
                            
                            if (iApp.sharedInstance.getAllowMessagesGCM() == 1) {
                                
                                createNotify(id: "message", title: NSLocalizedString("label_new_message_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_message", comment: ""))
                            }
                        }
                        
                        if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId && iApp.sharedInstance.getCurrentChatId() == mChatId) {
                            
                            iApp.sharedInstance.msg.setId(id: Int((remoteMessage["msgId"] as? NSString)! as String)!)
                            iApp.sharedInstance.msg.setFromUserId(fromUserId: Int((remoteMessage["msgFromUserId"] as? NSString)! as String)!)
                            iApp.sharedInstance.msg.setText(text:  (remoteMessage["msgMessage"] as? NSString)! as String)
                            iApp.sharedInstance.msg.setPhotoUrl(photoUrl: (remoteMessage["msgFromUserPhotoUrl"] as? NSString)! as String)
                            iApp.sharedInstance.msg.setFullname(fullname: (remoteMessage["msgFromUserFullname"] as? NSString)! as String)
                            iApp.sharedInstance.msg.setUsername(username: (remoteMessage["msgFromUserUsername"] as? NSString)! as String)
                            iApp.sharedInstance.msg.setImgUrl(imgUrl: (remoteMessage["msgImgUrl"] as? NSString)! as String)
                            iApp.sharedInstance.msg.setTimeAgo(timeAgo: (remoteMessage["msgTimeAgo"] as? NSString)! as String)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateChat"), object: nil)
                        }
                        
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_SEEN:
                    
                    let mChatId = Int((remoteMessage["id"] as? NSString)! as String)!
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId && iApp.sharedInstance.getCurrentChatId() == mChatId) {
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "seenChat"), object: nil)
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_TYPING_START:
                    
                    let mChatId = Int((remoteMessage["id"] as? NSString)! as String)!
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId && iApp.sharedInstance.getCurrentChatId() == mChatId) {
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "typingStartChat"), object: nil)
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_TYPING_END:
                    
                    let mChatId = Int((remoteMessage["id"] as? NSString)! as String)!
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId && iApp.sharedInstance.getCurrentChatId() == mChatId) {
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "typingEndChat"), object: nil)
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_LIKE:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        
                        if (iApp.sharedInstance.getAllowLikesGCM() == 1) {
                            
                            createNotify(id: "like", title: NSLocalizedString("label_new_like_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_like", comment: ""))
                        }
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_COMMENT:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        
                        if (iApp.sharedInstance.getAllowCommentsGCM() == 1) {
                            
                            createNotify(id: "comment", title: NSLocalizedString("label_new_comment_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_comment", comment: ""))
                        }
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_COMMENT_REPLY:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        
                        if (iApp.sharedInstance.getAllowCommentsGCM() == 1) {
                            
                            createNotify(id: "comment_reply", title: NSLocalizedString("label_new_comment_reply_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_comment_reply", comment: ""))
                        }
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_GIFT:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        
                        if (iApp.sharedInstance.getAllowGiftsGCM() == 1) {
                            
                            createNotify(id: "gift", title: NSLocalizedString("label_new_gift_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_gift", comment: ""))
                        }
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_IMAGE_LIKE:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        
                        if (iApp.sharedInstance.getAllowLikesGCM() == 1) {
                            
                            createNotify(id: "like", title: NSLocalizedString("label_new_like_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_like", comment: ""))
                        }
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_IMAGE_COMMENT:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        
                        if (iApp.sharedInstance.getAllowCommentsGCM() == 1) {
                            
                            createNotify(id: "comment", title: NSLocalizedString("label_new_comment_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_comment", comment: ""))
                        }
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_IMAGE_COMMENT_REPLY:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        
                        if (iApp.sharedInstance.getAllowCommentsGCM() == 1) {
                            
                            createNotify(id: "comment_reply", title: NSLocalizedString("label_new_comment_reply_title", comment: ""), subtitle: "", body: NSLocalizedString("label_new_comment_reply", comment: ""))
                        }
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_MEDIA_APPROVE:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        
                        createNotify(id: "moderation", title: NSLocalizedString("label_media_title", comment: ""), subtitle: "", body: NSLocalizedString("label_media_approve", comment: ""))
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_MEDIA_REJECT:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        
                        createNotify(id: "moderation", title: NSLocalizedString("label_media_title", comment: ""), subtitle: "", body: NSLocalizedString("label_media_reject", comment: ""))
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_PROFILE_PHOTO_REJECT:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        
                        iApp.sharedInstance.setPhotoUrl(photoUrl: "")
                        
                        createNotify(id: "moderation", title: NSLocalizedString("label_profile_photo_title", comment: ""), subtitle: "", body: NSLocalizedString("label_profile_photo_reject", comment: ""))
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_PROFILE_COVER_REJECT:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        iApp.sharedInstance.setNotificationsCount(notificationsCount: iApp.sharedInstance.getNotificationsCount() + 1)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBadges"), object: nil)
                        
                        iApp.sharedInstance.setCoverUrl(coverUrl: "")
                        
                        createNotify(id: "moderation", title: NSLocalizedString("label_profile_cover_title", comment: ""), subtitle: "", body: NSLocalizedString("label_profile_cover_reject", comment: ""))
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_SYSTEM:
                    
                    let app_title = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                    
                    let fcm_message = remoteMessage["msg"] as? NSString
                    
                    createNotify(id: "system", title: app_title, subtitle: "", body: fcm_message! as String)
                    
                    break
                    
                case Constants.GCM_NOTIFY_CUSTOM:
                    
                    if (iApp.sharedInstance.getId() != 0) {
                        
                        let app_title = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                        
                        let fcm_message = remoteMessage["msg"] as? NSString
                        
                        createNotify(id: "custom", title: app_title, subtitle: "", body: fcm_message! as String)
                    }
                    
                    break
                    
                case Constants.GCM_NOTIFY_PERSONAL:
                    
                    if (iApp.sharedInstance.getId() != 0 && iApp.sharedInstance.getId() == mAccountId) {
                        
                        let app_title = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                        
                        let fcm_message = remoteMessage["msg"] as? NSString
                        
                        createNotify(id: "personal", title: app_title, subtitle: "", body: fcm_message! as String)
                    }
                    
                    break
                    
                default:
                    
                    break
                }
                
            }
        }
    }
    
    func createNotify(id: String, title: String, subtitle: String, body: String) {
        
        print("notification will be triggered in five seconds..Hold on tight")
        
        let content = UNMutableNotificationContent()
        content.title = title
        
        if (subtitle.count > 0) {
            
            content.subtitle = subtitle
        }
        
        if (body.count > 0) {
            
            content.body = body
        }
        
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error!.localizedDescription)
            }
        }
    }
    
}

// [END ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate:UNUserNotificationCenterDelegate {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == "follower" {
            
            completionHandler( [.banner,.sound,.badge])
            
        } else if (notification.request.identifier == "message") {
            
            completionHandler( [.banner,.sound,.badge])
            
        } else if (notification.request.identifier == "like") {
            
            completionHandler( [.banner,.sound,.badge])
            
        } else if (notification.request.identifier == "comment") {
            
            completionHandler( [.banner,.sound,.badge])
            
        } else if (notification.request.identifier == "comment_reply") {
            
            completionHandler( [.banner,.sound,.badge])
            
        } else if (notification.request.identifier == "gift") {
            
            completionHandler( [.banner,.sound,.badge])
            
        } else if (notification.request.identifier == "system") {
            
            completionHandler( [.banner,.sound,.badge])
            
        } else if (notification.request.identifier == "custom") {
            
            completionHandler( [.banner,.sound,.badge])
            
        } else if (notification.request.identifier == "personal") {
            
            completionHandler( [.banner,.sound,.badge])
            
        } else if (notification.request.identifier == "moderation") {
            
            completionHandler( [.banner,.sound,.badge])
        }
    }
}

// [END ios_10_message_handling]

// [START ios_10_data_message_handling]

extension AppDelegate : MessagingDelegate {
    
    // Receive new FCM token and save
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("Firebase registration token: \(fcmToken!)")
        
        iApp.sharedInstance.setFcmRegId(ios_fcm_regid: fcmToken!)
        
        //let dataDict:[String: String] = ["token": fcmToken]
        
        //NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        print("Firebase registration token: \(iApp.sharedInstance.getFcmRegId())")
    }
    
}
