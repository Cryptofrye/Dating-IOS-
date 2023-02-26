//
//  GalleryItem.swift
//  iMyFirstApp
//
//  Created by Mac Book on 19.01.17.
//  Copyright © 2018 racconsquare@gmail.com. All rights reserved.
//

import UIKit

class GalleryItem {

    private var fromUserUsername: String?
    private var fromUserFullname: String?
    private var imgUrl: String?
    private var image = UIImage()
    public var imgLoading = false
    
    init(Response: AnyObject) {
        
        self.setFromUserFullname(fromUserFullname: (Response["fromUserFullname"] as? String)!)
        self.setFromUserUsername(fromUserUsername: (Response["fromUserUsername"] as? String)!)
        self.setImgUrl(imgUrl: (Response["imgUrl"] as? String)!)
        
    }
    
    public func setImage(image: UIImage) {
        
        self.image = image;
    }
    
    public func getImage()->UIImage {
        
        return self.image;
    }
    
    public func setFromUserUsername(fromUserUsername: String) {
        
        self.fromUserUsername = fromUserUsername
    }
    
    public func getFromUserUsername()->String {
        
        return self.fromUserUsername!
    }
    
    public func setFromUserFullname(fromUserFullname: String) {
        
        self.fromUserFullname = fromUserFullname
    }
    
    public func getFromUserFullname()->String {
        
        return self.fromUserFullname!
    }
    
    public func setImgUrl(imgUrl: String) {
        
        self.imgUrl = imgUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getImgUrl()->String {
        
        return self.imgUrl!
    }
}
